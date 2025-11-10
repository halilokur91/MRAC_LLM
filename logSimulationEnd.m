function logSimulationEnd()
%logSimulationEnd - End simulation logging
%   Stops MATLAB diary and writes end marker

    % Simulation end marker
    separator = '═══════════════════════════════════════════════════════\n';
    endMsg = '🏁 MRAC SIMULATION ENDED\n';
    timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
    footer = sprintf('[%s] %s', timestamp, endMsg);
    
    fprintf('\n%s%s%s\n', separator, footer, separator);
    
    % Turn off diary to stop logging
    diary off;
    fprintf('✅ Diary stopped - All command window output has been saved\n');
end

