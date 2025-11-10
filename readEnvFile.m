function env = readEnvFile(filepath)
    % READENVFILE  Reads .env file and returns KEY→VALUE struct
    %
    %   env = READENVFILE(filepath)
    %
    %   .env file format (each line):
    %     KEY=VALUE
    %   Comment lines start with "#", blank lines are skipped.

    fid = fopen(filepath, 'r');
    if fid<0
        error('readEnvFile: Could not open file: %s', filepath);
    end

    env = struct();
    while ~feof(fid)
        line = strtrim(fgetl(fid));
        
        % Skip blank lines and comment lines
        if isempty(line) || startsWith(line, '#')
            continue
        end
        
        % Skip lines without = sign
        if ~contains(line, '=')
            warning('readEnvFile: Skipped invalid line (no equals sign): %s', line);
            continue
        end
        
        parts = strsplit(line, '=');
        if numel(parts) < 2
            warning('readEnvFile: Geçersiz satır atlandı: %s', line);
            continue
        end
        
        key   = strtrim(parts(1));
        value = strtrim(strjoin(parts(2:end), '='));  % = içeren değerler için
        
        % Boş key veya value kontrolü
        if isempty(key) || isempty(value)
            warning('readEnvFile: Boş key veya value atlandı: %s', line);
            continue
        end
        
        % Değerdeki tırnakları kaldır (opsiyonel)
        if startsWith(value, '"') && endsWith(value, '"')
            value = value(2:end-1);
        elseif startsWith(value, '''') && endsWith(value, '''')
            value = value(2:end-1);
        end

        % struct alanı olarak ekle
        % (alan adı olarak geçerli harf-rakam-_ kombinasyonu kullan)
        try
            safeKey = matlab.lang.makeValidName(key);
            if ~isempty(safeKey) && ~strcmp(safeKey, 'x')
                env.(safeKey) = value;
                % Ortam değişkeni olarak da ayarla
                setenv(key, value);
            else
                warning('readEnvFile: Geçersiz key adı atlandı: %s', key);
            end
        catch ME
            warning('readEnvFile: Key işlenirken hata oluştu (%s): %s', key, ME.message);
            continue
        end
    end

    fclose(fid);
end 