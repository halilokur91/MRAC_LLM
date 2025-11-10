function logSystem(logType, data, varargin)
%LOGSYSTEM Comprehensive logging system - Single log file system
%   logType: 'apprentice', 'master', 'simulink', 'system', 'error', 'simulation'
%   data: Data to log
%   varargin: Additional parameters (iteration number, etc.)

    % Log folder check
    logDir = 'logs';
    if ~exist(logDir, 'dir')
        mkdir(logDir);
    end
    
    % Single log file - simulation_latest.txt (overwrite each session)
    logFilename = fullfile(logDir, 'simulation_latest.txt');
    
    % Prefix by log type
    switch logType
        case 'apprentice'
            prefix = '🔧 APPRENTICE';
        case 'master'
            prefix = '🧠 MASTER';
        case 'simulink'
            prefix = '⚙️ SIMULINK';
        case 'system'
            prefix = '🖥️ SYSTEM';
        case 'error'
            prefix = '❌ ERROR';
        case 'simulation'
            prefix = '🎯 SIMULATION';
        case 'command'
            prefix = '💻 COMMAND';
        case 'iteration'
            prefix = '🔄 ITERATION';
        otherwise
            prefix = '📝 GENERAL';
    end
    
    % Check iteration number
    iteration = '';
    if nargin > 2
        iteration = sprintf(' [Iter %d]', varargin{1});
    end
    
    % Create timestamp
    timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
    
    % Create log message
    logMessage = sprintf('[%s] %s%s: %s\n', timestamp, prefix, iteration, data);
    
    % Write to file
    try
        fid = fopen(logFilename, 'a');
        if fid ~= -1
            fprintf(fid, '%s', logMessage);
            fclose(fid);
        end
        
        % Also print to console (for debugging)
        fprintf('%s', logMessage);
        
    catch ME
        fprintf('❌ Logging error: %s\n', ME.message);
    end
end 