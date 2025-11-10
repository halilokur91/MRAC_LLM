function logSimulationStart()
%logSimulationStart - Start simulation logging with diary
%   Clears the log file and starts MATLAB diary to capture all command window output

    % Simulation start marker - Clear file and start fresh
    separator = '═══════════════════════════════════════════════════════\n';
    startMsg = '🎯 MRAC SIMULATION STARTED\n';
    timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
    header = sprintf('[%s] %s', timestamp, startMsg);
    
    % Ensure logs directory exists
    logDir = 'logs';
    if ~exist(logDir, 'dir')
        mkdir(logDir);
    end
    
    logFilename = fullfile(logDir, 'simulation_latest.txt');
    
    try
        % Turn off any existing diary
        diary off;
        
        % Use 'w' to overwrite the file (start fresh)
        fid = fopen(logFilename, 'w');
        if fid ~= -1
            fprintf(fid, '\n%s%s%s\n', separator, header, separator);
            fprintf(fid, '📋 COMPLETE COMMAND WINDOW CONTENT:\n');
            fprintf(fid, '─────────────────────────────────────────────────────\n\n');
            fclose(fid);
        end
        
        % Start diary to capture ALL command window output
        diary(logFilename);
        fprintf('✅ Diary started - All command window output will be logged to: %s\n', logFilename);
    catch ME
        fprintf('❌ Log start error: %s\n', ME.message);
    end
end

