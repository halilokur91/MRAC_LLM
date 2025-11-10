function runMRACSimple(app)
% MRAC simülasyonunu app entegrasyonu ile basit şekilde çalıştırır
% Progress bar sorunları olmadan çalışır

try
    fprintf('=== MRAC Simülasyonu Başlatılıyor ===\n');
    
    % Status label güncelle
    if isprop(app, 'StatusLabel') && isvalid(app.StatusLabel)
        app.StatusLabel.Text = 'Simülasyon başlatılıyor...';
        app.StatusLabel.FontColor = [0.8 0.4 0.0]; % Turuncu
        drawnow;
    end
    
    % Model tipi al
    if isprop(app, 'ModelTypeDropDown')
        modelType = app.ModelTypeDropDown.Value;
        refType = 'GUI'; % Artık her zaman from GUI fields alınacak
        
        % Debug bilgisi
        fprintf('App''ten alınan parametreler:\n');
        fprintf('  Model Type: %s\n', modelType);
        fprintf('  Referans Tipi: %s\n', refType);
    else
        modelType = 'Classic MRAC'; % Default
        refType = 'Varsayılan';
        fprintf('App dropdown''ları bulunamadı, varsayılan değerler kullanılıyor.\n');
    end
    
    fprintf('Model Type: %s\n', modelType);
    fprintf('Referans Tipi: %s\n', refType);
    
    % Workspace'e parametreleri gönder
    assignin('base', 'modelType', modelType);
    assignin('base', 'refType', refType);
    assignin('base', 'app', app); % App handle'ını gönder
    
    % Status güncelle
    if isprop(app, 'StatusLabel') && isvalid(app.StatusLabel)
        app.StatusLabel.Text = 'MRAC simülasyonu çalışıyor...';
        drawnow;
    end
    
    % Referans model parametrelerini ayarla
    if strcmp(refType, 'Performans Hedefi') && isprop(app, 'OvershootDropDown')
        overshoot = app.OvershootDropDown.Value;
        settling = app.SettlingTimeDropDown.Value;
        assignin('base', 'overshoot', overshoot);
        assignin('base', 'settling', settling);
        fprintf('Performans hedefi parametreleri:\n');
        fprintf('  Aşım: %s\n', overshoot);
        fprintf('  Yerleşme Süresi: %s\n', settling);
    elseif strcmp(refType, 'Manuel') && isprop(app, 'AMatrixEdit')
        A_val = app.AMatrixEdit.Value;
        B_val = app.BMatrixEdit.Value;
        C_val = app.CMatrixEdit.Value;
        D_val = app.DMatrixEdit.Value;
        assignin('base', 'A', A_val);
        assignin('base', 'B', B_val);
        assignin('base', 'C', C_val);
        assignin('base', 'D', D_val);
        fprintf('Manuel matris parametreleri:\n');
        fprintf('  A: %s\n', A_val);
        fprintf('  B: %s\n', B_val);
        fprintf('  C: %s\n', C_val);
        fprintf('  D: %s\n', D_val);
    else
        fprintf('Referans model parametreleri: Varsayılan kullanılacak\n');
    end
    
    % MRAC script'ini çalıştır
    fprintf('mrac_combined.m çalıştırılıyor...\n');
    run('mrac_combined.m');
    
    % Status güncelle
    if isprop(app, 'StatusLabel') && isvalid(app.StatusLabel)
        app.StatusLabel.Text = 'Sonuçlar işleniyor...';
        drawnow;
    end
    
    % Plotları güncelle
    if isprop(app, 'updatePlotsFromWorkspace')
        app.updatePlotsFromWorkspace();
    else
        updatePlotsSimple(app);
    end
    
    % Başarı mesajı
    if isprop(app, 'StatusLabel') && isvalid(app.StatusLabel)
        app.StatusLabel.Text = 'Simülasyon başarıyla tamamlandı';
        app.StatusLabel.FontColor = [0.2 0.6 0.2]; % Yeşil
        drawnow;
    end
    
    fprintf('✅ Simülasyon başarıyla tamamlandı!\n');
    
catch ME
    % Hata durumu
    if isprop(app, 'StatusLabel') && isvalid(app.StatusLabel)
        app.StatusLabel.Text = ['Hata: ' ME.message];
        app.StatusLabel.FontColor = [0.8 0.2 0.2]; % Kırmızı
    end
    
    fprintf('❌ HATA: %s\n', ME.message);
    fprintf('Stack trace:\n');
    for i = 1:length(ME.stack)
        fprintf('  %s (line %d)\n', ME.stack(i).name, ME.stack(i).line);
    end
end

end

function updatePlotsSimple(app)
% Basit plot güncelleme fonksiyonu
try
    % Workspace'ten verileri çek ve format düzenle
    if evalin('base', 'exist(''X'', ''var'')')
        X = evalin('base', 'X');
        % Veri formatını kontrol et
        if isa(X, 'timeseries')
            dataX = X.Data;
            time = X.Time;
        elseif isstruct(X) && isfield(X, 'signals')
            dataX = X.signals.values;
            time = X.time;
        else
            dataX = X;
            if evalin('base', 'exist(''t'', ''var'')')
                time = evalin('base', 't');
            end
        end
    end
    
    if evalin('base', 'exist(''Xm'', ''var'')')
        Xm = evalin('base', 'Xm');
        % Veri formatını kontrol et
        if isa(Xm, 'timeseries')
            dataXm = Xm.Data;
            % time zaten X'ten alındı olabilir
            if ~exist('time', 'var')
                time = Xm.Time;
            end
        elseif isstruct(Xm) && isfield(Xm, 'signals')
            dataXm = Xm.signals.values;
            if ~exist('time', 'var')
                time = Xm.time;
            end
        else
            dataXm = Xm;
        end
    end
    
    % time hala yoksa t'yi kontrol et
    if ~exist('time', 'var') && evalin('base', 'exist(''t'', ''var'')')
        time = evalin('base', 't');
    end
    
    % ErrorAxes'te profesyonel plot
    if isprop(app, 'ErrorAxes') && exist('dataX', 'var') && exist('dataXm', 'var') && exist('time', 'var')
        % Axes'i tamamen temizle
        cla(app.ErrorAxes, 'reset');
        hold(app.ErrorAxes, 'off');
        
        % Veri boyutlarını kontrol et
        if size(dataX, 2) > 1, plotDataX = dataX(:, 1); else, plotDataX = dataX; end
        if size(dataXm, 2) > 1, plotDataXm = dataXm(:, 1); else, plotDataXm = dataXm; end
        
        % Modern renkler ve stiller - Temiz plot
        plot(app.ErrorAxes, time, plotDataX, 'Color', [0.2 0.4 0.8], 'LineWidth', 2.5, ...
            'DisplayName', 'Sistem Çıkışı');
        hold(app.ErrorAxes, 'on');
        plot(app.ErrorAxes, time, plotDataXm, 'Color', [0.8 0.2 0.2], 'LineWidth', 2.5, ...
            'DisplayName', 'Referans Model', 'LineStyle', '--');
        hold(app.ErrorAxes, 'off');
        
        % Profesyonel görünüm
        title(app.ErrorAxes, '🚀 MRAC Simülasyonu - Sistem Takibi', ...
            'FontSize', 14, 'FontWeight', 'bold', 'Color', [0.2 0.2 0.2]);
        xlabel(app.ErrorAxes, 'Time (seconds)', 'FontSize', 12, 'FontWeight', 'bold');
        ylabel(app.ErrorAxes, 'Çıkış Sinyali', 'FontSize', 12, 'FontWeight', 'bold');
        
        % Temiz legend
        legend(app.ErrorAxes, 'Location', 'best', 'FontSize', 11, ...
            'Box', 'on', 'Color', [0.95 0.95 0.95]);
        
        grid(app.ErrorAxes, 'on');
        app.ErrorAxes.GridAlpha = 0.3;
        app.ErrorAxes.XColor = [0.3 0.3 0.3]; app.ErrorAxes.YColor = [0.3 0.3 0.3];
        
        % Eksen limitleri - Güvenli
        xlim(app.ErrorAxes, [min(time) max(time)]);
        y_min = min([min(plotDataX) min(plotDataXm)]);
        y_max = max([max(plotDataX) max(plotDataXm)]);
        if y_min ~= y_max && ~isnan(y_min) && ~isnan(y_max)
            margin = 0.1 * (y_max - y_min);
            ylim(app.ErrorAxes, [y_min - margin, y_max + margin]);
        end
    end
    
    % Hata sinyalini profesyonel olarak plotla (eğer varsa)
    if isprop(app, 'ThetaAxes') && evalin('base', 'exist(''eTPB'', ''var'')')
        eTPB = evalin('base', 'eTPB');
        
        % eTPB formatını kontrol et
        if isa(eTPB, 'timeseries')
            errorData = eTPB.Data;
            errorTime = eTPB.Time;
        elseif isstruct(eTPB) && isfield(eTPB, 'signals')
            errorData = eTPB.signals.values;
            errorTime = eTPB.time;
        else
            errorData = eTPB;
            errorTime = time;
        end
        
        if exist('errorTime', 'var') && exist('errorData', 'var')
            % Axes'i tamamen temizle
            cla(app.ThetaAxes, 'reset');
            hold(app.ThetaAxes, 'off');
            
            % Çok boyutluysa ilk sütunu al
            if size(errorData, 2) > 1
                plotErrorData = errorData(:, 1);
            else
                plotErrorData = errorData;
            end
            
            % Hata sinyali - Temiz plot
            plot(app.ThetaAxes, errorTime, plotErrorData, 'Color', [0.8 0.1 0.1], ...
                'LineWidth', 2.5, 'DisplayName', 'Takip Hatası');
            
            % Sıfır referans çizgisi
            hold(app.ThetaAxes, 'on');
            plot(app.ThetaAxes, [min(errorTime) max(errorTime)], [0 0], ...
                'Color', [0.5 0.5 0.5], 'LineWidth', 1, 'LineStyle', ':', ...
                'DisplayName', 'Sıfır Referans');
            hold(app.ThetaAxes, 'off');
            
            % Profesyonel görünüm
            title(app.ThetaAxes, '📊 Takip Hatası (eTPB)', ...
                'FontSize', 14, 'FontWeight', 'bold', 'Color', [0.2 0.2 0.2]);
            xlabel(app.ThetaAxes, 'Time (seconds)', 'FontSize', 12, 'FontWeight', 'bold');
            ylabel(app.ThetaAxes, 'Hata Büyüklüğü', 'FontSize', 12, 'FontWeight', 'bold');
            
            % Temiz legend
            legend(app.ThetaAxes, 'Location', 'best', 'FontSize', 11, ...
                'Box', 'on', 'Color', [0.95 0.95 0.95]);
            
            grid(app.ThetaAxes, 'on');
            app.ThetaAxes.GridAlpha = 0.3;
            app.ThetaAxes.XColor = [0.3 0.3 0.3]; app.ThetaAxes.YColor = [0.3 0.3 0.3];
            
            % Eksen limitleri - Güvenli
            xlim(app.ThetaAxes, [min(errorTime) max(errorTime)]);
            if ~all(isnan(plotErrorData)) && ~all(isinf(plotErrorData))
                y_min = min(plotErrorData);
                y_max = max(plotErrorData);
                if y_min ~= y_max && ~isnan(y_min) && ~isnan(y_max)
                    margin = 0.1 * abs(y_max - y_min);
                    ylim(app.ThetaAxes, [y_min - margin, y_max + margin]);
                end
            end
        end
    end
    
    fprintf('✅ Plotlar güncellendi\n');
    
catch ME
    fprintf('❌ Plot güncelleme hatası: %s\n', ME.message);
end
end

