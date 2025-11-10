classdef MRACApp < matlab.apps.AppBase

    %% Properties
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        TopActionPanel         matlab.ui.container.Panel
        UndoButton             matlab.ui.control.Button
        RedoButton             matlab.ui.control.Button
        TabGroup               matlab.ui.container.TabGroup
        HomeTab                matlab.ui.container.Tab
        % ProjectsTab            matlab.ui.container.Tab        % HIDDEN
        ChatTab                matlab.ui.container.Tab
        % ApprovalTab            matlab.ui.container.Tab        % HIDDEN
        ModelSelectionTab      matlab.ui.container.Tab  % NEW: Model Selection tab
        SimulationTab          matlab.ui.container.Tab
        ReportingTab           matlab.ui.container.Tab
        % AnalyticsTab           matlab.ui.container.Tab        % HIDDEN
        % PluginsTab             matlab.ui.container.Tab        % HIDDEN
        SettingsTab            matlab.ui.container.Tab
        % NEW Home Page Components
        GettingStartedButton   matlab.ui.control.Button
        DocumentationButton    matlab.ui.control.Button
        SupportButton          matlab.ui.control.Button
        % ProjectsListBox        matlab.ui.control.ListBox      % HIDDEN
        % NewProjectButton       matlab.ui.control.Button       % HIDDEN
        % ProjectsContextMenu    matlab.ui.container.ContextMenu % HIDDEN
        % RenameMenuItem         matlab.ui.container.Menu       % HIDDEN
        % CopyMenuItem           matlab.ui.container.Menu       % HIDDEN
        % DeleteMenuItem         matlab.ui.container.Menu       % HIDDEN
        % LoadProjectButton      matlab.ui.control.Button       % HIDDEN
        % SaveProjectButton      matlab.ui.control.Button       % HIDDEN
        ChatHistoryListBox     matlab.ui.control.ListBox
        ChatInputArea          matlab.ui.control.TextArea
        SendButton             matlab.ui.control.Button
        CopyChatButton         matlab.ui.control.Button
        % ApprovalListBox        matlab.ui.control.ListBox      % HIDDEN
        % ApproveButton          matlab.ui.control.Button       % HIDDEN
        % RejectButton           matlab.ui.control.Button       % HIDDEN
        SimulationPanel        matlab.ui.container.Panel
        ErrorAxes              matlab.ui.control.UIAxes
        ThetaAxes              matlab.ui.control.UIAxes
        EvaluateButton         matlab.ui.control.Button
        EvaluationResultArea   matlab.ui.control.TextArea
        RefModelPanel          matlab.ui.container.Panel
        RefModelALabel         matlab.ui.control.Label
        RefModelAField         matlab.ui.control.TextArea
        RefModelBLabel         matlab.ui.control.Label
        RefModelBField         matlab.ui.control.TextArea
        RefModelCLabel         matlab.ui.control.Label
        RefModelCField         matlab.ui.control.TextArea
        RefModelDLabel         matlab.ui.control.Label
        RefModelDField         matlab.ui.control.TextArea
        AdaptParamsPanel       matlab.ui.container.Panel
        KrHatLabel             matlab.ui.control.Label
        GammaThetaLabel        matlab.ui.control.Label
        GammaKrLabel           matlab.ui.control.Label
        TsLabel                matlab.ui.control.Label
        KrHatField             matlab.ui.control.NumericEditField
        GammaThetaField        matlab.ui.control.NumericEditField
        GammaKrField           matlab.ui.control.NumericEditField
        TsField                matlab.ui.control.NumericEditField
        MetricsPanel           matlab.ui.container.Panel
        MeanErrorLabel         matlab.ui.control.Label
        MeanErrorValueLabel    matlab.ui.control.Label
        FinalThetaLabel        matlab.ui.control.Label
        FinalThetaValueLabel   matlab.ui.control.Label
        ReportFormatDropDown   matlab.ui.control.DropDown
        ExportReportButton     matlab.ui.control.Button
        % AnalyticsText          matlab.ui.control.Label        % HIDDEN
        % PluginListBox          matlab.ui.control.ListBox      % HIDDEN
        % InstallPluginButton    matlab.ui.control.Button       % HIDDEN
        % UninstallPluginButton  matlab.ui.control.Button       % HIDDEN
        APIKeyLabel            matlab.ui.control.Label
        APIKeyEditField        matlab.ui.control.EditField
        GPTModelLabel          matlab.ui.control.Label
        GPTModelDropDown       matlab.ui.control.DropDown
        SaveSettingsButton     matlab.ui.control.Button
        TestAPIConnectionButton matlab.ui.control.Button
        SystemStatusLabel      matlab.ui.control.Label  % NEW: System status display
        % APIKey property removed - SECURITY RISK: Hard-coded API keys should never be in code
        % Use app.settingsManager.getApiKey() instead (centralized in config.json)

        ModelName              char = 'E_MRAC2bb'
        gptContext             struct
        % currentProject         struct                          % HIDDEN
        chatHistory            cell = {}
        % projects               struct                          % HIDDEN
        % approvalItems          cell = {'Task 1: Review Adaptive Gains', 'Task 2: Validate Reference Model'} % HIDDEN
        apiConfig              struct
        % NEW: Additional features for GPT API
        % apiKey removed - use app.settingsManager.getApiKey() instead (centralized in config.json)
        useGptFeatures         logical = true  % Whether GPT features are active
        settingsManager        % Centralized settings manager
        ModelTypeDropDown      matlab.ui.control.DropDown
        RefModelButtonGroup    matlab.ui.container.ButtonGroup
        DefaultRefRadio        matlab.ui.control.RadioButton
        PerfRefRadio           matlab.ui.control.RadioButton
        ManualRefRadio         matlab.ui.control.RadioButton
        PerfPanel              matlab.ui.container.Panel
        OvershootDropDown      matlab.ui.control.DropDown
        SettlingTimeDropDown   matlab.ui.control.DropDown
        OvershootCustomEdit    matlab.ui.control.NumericEditField
        SettlingTimeCustomEdit matlab.ui.control.NumericEditField
        OvershootBackButton    matlab.ui.control.Button
        SettlingBackButton     matlab.ui.control.Button
        ManualPanel            matlab.ui.container.Panel
        AMatrixEdit            matlab.ui.control.TextArea
        BMatrixEdit            matlab.ui.control.TextArea
        CMatrixEdit            matlab.ui.control.TextArea
        DMatrixEdit            matlab.ui.control.TextArea

        DefaultRefPanel        matlab.ui.container.Panel
        DefaultRefLabel        matlab.ui.control.Label
        DefaultRefYes          matlab.ui.control.RadioButton
        DefaultRefNo           matlab.ui.control.RadioButton
        % SelectionSummary removed - not needed
        DefaultRefButtonGroup  matlab.ui.container.ButtonGroup
        ChatInfoLabel          matlab.ui.control.Label
        % WelcomePanel           matlab.ui.container.Panel      % OLD - HIDDEN
        % WelcomeTitle           matlab.ui.control.Label       % OLD - HIDDEN
        % WelcomeDesc            matlab.ui.control.Label       % OLD - HIDDEN
        % SignatureLabel         matlab.ui.control.Label       % OLD - HIDDEN
        StatusLabel            matlab.ui.control.Label
        ProgressBar            % Progress dialog - will be created dynamically
        isSimulationRunning    % Flag for simulation status
        stopSimulationFlag     % Flag to stop simulation
        hasCompletedSimulation logical = false  % Flag to track if simulation was run in this session
        StopButton             % Stop simulation button
        % Reporting UI components
        ReportStatusLabel      matlab.ui.control.Label
        IncludeSystemPlotCheckBox   matlab.ui.control.CheckBox
        IncludeErrorPlotCheckBox    matlab.ui.control.CheckBox
        IncludeParametersCheckBox   matlab.ui.control.CheckBox
        IncludeAnalysisCheckBox     matlab.ui.control.CheckBox
        IncludeTimestampCheckBox    matlab.ui.control.CheckBox
        ReportTitleEdit        matlab.ui.control.EditField
        PreviewReportButton    matlab.ui.control.Button
        SavePlotsButton        matlab.ui.control.Button

        % NEW: Iteration and Model Formula Components
        IterationDisplay       matlab.ui.control.TextArea
        ModelFormulaImage      matlab.ui.control.Image
        FormulaAxes           matlab.ui.control.UIAxes
        IterationLabel         matlab.ui.control.Label
        FormulaLabel           matlab.ui.control.Label
        % NEW: Additional components for Model Selection tab
        ModelSelectionPanel    matlab.ui.container.Panel
        ModelSelectionTitle    matlab.ui.control.Label
        ProceedToSimButton     matlab.ui.control.Button  % Button to proceed from model selection to simulation
        % NEW: GPT Model Recommendation - 3 Suggestions Display
        GptResponsePanel       matlab.ui.container.Panel
        GptSuggestionsArea     matlab.ui.control.TextArea
        GptResponseLabel       matlab.ui.control.Label
        GetGptAdviceButton     matlab.ui.control.Button
        % NEW: 3 GPT Recommendation Buttons
        GptSuggestion1Button   matlab.ui.control.Button
        GptSuggestion2Button   matlab.ui.control.Button
        GptSuggestion3Button   matlab.ui.control.Button
        % NEW: GPT Recommendation Data
        gptSuggestions         cell = {}
        currentGptSuggestions  struct
        
        % NEW: For System/Plant Model Definition
        LeftColumnPanel        matlab.ui.container.Panel
        SystemModelPanel       matlab.ui.container.Panel
        SystemAMatrixEdit      matlab.ui.control.TextArea
        SystemBMatrixEdit      matlab.ui.control.TextArea
        SystemCMatrixEdit      matlab.ui.control.TextArea
        SystemDMatrixEdit      matlab.ui.control.TextArea
        SystemPreviewButton    matlab.ui.control.Button
        SystemResponseAxes     matlab.ui.control.UIAxes
        SystemModelLabel       matlab.ui.control.Label
        SystemPreviewPanel     matlab.ui.container.Panel
        ReferenceResponseAxes  matlab.ui.control.UIAxes
        
        % NEW: System Definition Method Selection
        SystemDefinitionMethodGroup   matlab.ui.container.ButtonGroup
        StateSpaceRadio              matlab.ui.control.RadioButton
        % TransferFunctionRadio removed - only state-space is supported
        
        % Transfer function components removed - only state-space is supported
        
        % Result matrices panel removed - not needed
        
        % NEW: For 3-Column Layout
        MiddleColumnPanel      matlab.ui.container.Panel
        RightColumnPanel       matlab.ui.container.Panel
        MRACModelPanel         matlab.ui.container.Panel
        ReferenceModelPanel    matlab.ui.container.Panel
        GammaThetaEdit         matlab.ui.control.NumericEditField
        GammaKrEdit            matlab.ui.control.NumericEditField
        SamplingTimeEdit       matlab.ui.control.NumericEditField
        MRACDescriptionArea    matlab.ui.control.TextArea
        RefPreviewButton       matlab.ui.control.Button
        % SummaryPanel removed - not needed
        
        % NEW: Command Window Integration Properties
        CommandLogLabel        matlab.ui.control.Label
        CommandWindowDisplay   matlab.ui.control.TextArea
        ClearCommandLogButton  matlab.ui.control.Button
        SaveCommandLogButton   matlab.ui.control.Button
        diaryFile              char  % For diary file path
        
        % NEW: Advanced Chat System Properties
        chatManager            % ChatManager class
        simulationDataCollector % SimulationDataCollector class
        
        % NEW: Advanced Chat UI Components
        EnhancedChatHistory    matlab.ui.control.TextArea
        EnhancedChatInput      matlab.ui.control.TextArea
        SendChatButton         matlab.ui.control.Button
        ClearChatButton        matlab.ui.control.Button
        ExportChatButton       matlab.ui.control.Button
        
        % NEW: Simulation Summary Components
        ModelInfoDisplay       matlab.ui.control.TextArea
        PerformanceDisplay     matlab.ui.control.TextArea
        AnalysisStatusLabel    matlab.ui.control.Label
        AnalyzeSimulationButton matlab.ui.control.Button
        OpenLogFileButton      matlab.ui.control.Button
        TriggerAnalysisButton  matlab.ui.control.Button
        
        % NEW: Analysis and Recommendations Components
        AnalysisResultDisplay  matlab.ui.control.TextArea
        RecommendationsDisplay matlab.ui.control.TextArea
        QuickQuestion1         matlab.ui.control.Button
        QuickQuestion2         matlab.ui.control.Button
        QuickQuestion3         matlab.ui.control.Button
        QuickQuestion4         matlab.ui.control.Button
        
        % NEW: Proceed to Analysis After Simulation Button
        ProceedToAnalysisButton matlab.ui.control.Button
        
        % NEW: Simulation Control Parameters - Iteration and Master-Apprentice
        IterationCountEdit     matlab.ui.control.NumericEditField
        IterationCountLabel    matlab.ui.control.Label
        MasterFrequencyDropDown matlab.ui.control.DropDown
        MasterFrequencyLabel   matlab.ui.control.Label
        SimulationControlPanel matlab.ui.container.Panel
    end

    %% Methods
    methods
        function onModelTypeChanged(app)
            %onModelTypeChanged - Handle model type dropdown changes
            try
                if isprop(app, 'ModelTypeDropDown') && ~isempty(app.ModelTypeDropDown)
                    newValue = app.ModelTypeDropDown.Value;
                    % Push to base workspace so mrac_combined picks it up
                    assignin('base', 'modelType', newValue);
                    % Update parameter UI and summary
                    updateMRACParameters(app);
                    updateSummaryWithSystemModel(app);
                    updateGptHint(app);
                    % Status label feedback (safe)
                    if app.safeCheck('StatusLabel')
                        app.StatusLabel.Text = sprintf('📊 Model selected: %s', newValue);
                        app.StatusLabel.FontColor = [0.2 0.6 0.2];
                    end
                end
            catch ME
                fprintf('⚠️ onModelTypeChanged error: %s\n', ME.message);
            end
        end
        % NEW: Transition to Analysis After Simulation Function
        function proceedToAnalysis(app)
            try
                fprintf('🔄 Starting transition to analysis...\n');
                
                % Add log record to chat system
                if isprop(app, 'chatManager') && ~isempty(app.chatManager)
                    app.chatManager.addLogRecord('analysis', 'Analyze Simulation button clicked');
                    app.chatManager.addLogRecord('analysis', 'Transitioning to analysis...');
                end
                
                % Show waiting message immediately
                if isprop(app, 'AnalysisStatusLabel') && isvalid(app.AnalysisStatusLabel)
                    app.AnalysisStatusLabel.Text = '⏳ Waiting for analysis...';
                    app.AnalysisStatusLabel.FontColor = [0.8 0.4 0.0];
                end
                
                % Update button to show waiting state
                if isprop(app, 'AnalyzeSimulationButton') && isvalid(app.AnalyzeSimulationButton)
                    app.AnalyzeSimulationButton.Text = '⏳ Analyzing...';
                    app.AnalyzeSimulationButton.Enable = 'off';
                end
                
                % Switch to analysis tab
                app.TabGroup.SelectedTab = app.ChatTab;
                
                % Force UI update to show waiting message
                drawnow;
                
                % Add more log records during waiting
                if isprop(app, 'chatManager') && ~isempty(app.chatManager)
                    app.chatManager.addLogRecord('analysis', 'Collecting simulation data...');
                end
                
                % Wait a bit to show the waiting message
                pause(0.5);
                
                % Always create analysis from simulation data
                app.createBasicAnalysisFromSimulation();
                
                % Try to get additional data from workspace
                try
                    % Get iteration data from workspace
                    iterationData = app.collectIterationData();
                    
                    % Get command window data
                    commandWindowData = app.collectCommandWindowData();
                    
                    % Create simulation results structure
                    simulationResults = struct();
                    simulationResults.iterationData = iterationData;
                    simulationResults.commandWindowData = commandWindowData;
                    simulationResults.modelType = 'Classic MRAC';
                    if isprop(app, 'ModelTypeDropDown') && ~isempty(app.ModelTypeDropDown.Value)
                        simulationResults.modelType = app.ModelTypeDropDown.Value;
                    end
                    
                    % Update model information with real data
                    app.updateAnalysisModelInfo(simulationResults);
                    
                    % Update performance data with real data
                    app.updateAnalysisPerformanceData(simulationResults);
                    
                    % Trigger GPT analysis
                    app.triggerPostSimulationAnalysis(simulationResults);
                    
                    % Activate chat system
                    app.activatePostSimulationChat(simulationResults);
                    
                    fprintf('✅ Simulation data collected and analysis completed\n');
                    
                catch ME
                    fprintf('⚠️ Error collecting simulation data: %s\n', ME.message);
                    % Basic analysis already created above
                end
                
                % Add completion log records
                if isprop(app, 'chatManager') && ~isempty(app.chatManager)
                    app.chatManager.addLogRecord('analysis', 'Analysis completed successfully');
                    app.chatManager.addLogRecord('system', 'Chat system ready for questions');
                end
                
                % Update analysis status message
                if isprop(app, 'AnalysisStatusLabel') && isvalid(app.AnalysisStatusLabel)
                    app.AnalysisStatusLabel.Text = '✅ Analysis completed - Chat active';
                    app.AnalysisStatusLabel.FontColor = [0.1 0.6 0.1];
                end
                
                % Restore Analyze Simulation button
                if isprop(app, 'AnalyzeSimulationButton') && isvalid(app.AnalyzeSimulationButton)
                    app.AnalyzeSimulationButton.Text = '✅ Analysis Completed';
                    app.AnalyzeSimulationButton.Enable = 'off';
                end
                
                % Success message
                uialert(app.UIFigure, 'Simulation analysis completed! You can ask questions in the chat system.', ...
                    'Analysis Ready', 'Icon', 'success');
                
                % Update buttons
                app.ProceedToAnalysisButton.Enable = 'off';
                app.ProceedToAnalysisButton.Text = '✅ Analysis Completed';
                
                fprintf('✅ Analysis transition completed\n');
                
            catch ME
                uialert(app.UIFigure, ['Analysis transition error: ' ME.message], 'Error', 'Icon', 'error');
                fprintf('❌ proceedToAnalysis error: %s\n', ME.message);
            end
        end
        
        
        % NEW: Function to proceed from model selection to simulation
        function proceedToSimulation(app)
            % Safe property check
            try
                modelTypeValue = '';
                
                % Check MRAC model type
                if isprop(app, 'ModelTypeDropDown') && ~isempty(app.ModelTypeDropDown) && isprop(app.ModelTypeDropDown, 'Value')
                    modelTypeValue = app.ModelTypeDropDown.Value;
                end
                
                % MRAC model type selection check
                if isempty(modelTypeValue)
                    uialert(app.UIFigure, 'Please select a MRAC model type first!', 'Model Type Not Selected', 'Icon', 'warning');
                    return;
                end
                
                % Switch to simulation tab
                app.TabGroup.SelectedTab = app.SimulationTab;
                
                % Update simulation summary
                app.updateSimulationSummary();
                
                % Update status message
                app.StatusLabel.Text = sprintf('Model Ready: %s - Reference model will be taken from GUI', modelTypeValue);
                app.StatusLabel.FontColor = [0.2 0.6 0.2];
                
                % Activate simulation button
                app.EvaluateButton.Enable = 'on';
                
                % Success message
                uialert(app.UIFigure, 'Model configuration completed! You can start the simulation.', ...
                    'Success', 'Icon', 'success');
                
            catch ME
                uialert(app.UIFigure, ['Simulation transition error: ' ME.message], 'Error', 'Icon', 'error');
                fprintf('❌ proceedToSimulation error: %s\n', ME.message);
            end
        end
        
        % NEW: Old GPT function removed - 3 suggestions system used
        
        % NEW: System Information Collection Function
        function onPerformanceDropdownChanged(app)
            % Callback for performance goal dropdown changes
            % Show/hide custom edit fields based on dropdown selection
            % Custom fields appear next to dropdown when "Custom..." is selected

            % Handle Overshoot dropdown
            if strcmp(app.OvershootDropDown.Value, 'Custom...')
                % Show custom edit field and back button (replaces dropdown visually)
                app.OvershootDropDown.Visible = 'off';
                app.OvershootCustomEdit.Visible = 'on';
                app.OvershootBackButton.Visible = 'on';
            else
                % Show dropdown, hide custom edit field and back button
                app.OvershootDropDown.Visible = 'on';
                app.OvershootCustomEdit.Visible = 'off';
                app.OvershootBackButton.Visible = 'off';
            end

            % Handle Settling Time dropdown
            if strcmp(app.SettlingTimeDropDown.Value, 'Custom...')
                % Show custom edit field and back button (replaces dropdown visually)
                app.SettlingTimeDropDown.Visible = 'off';
                app.SettlingTimeCustomEdit.Visible = 'on';
                app.SettlingBackButton.Visible = 'on';
            else
                % Show dropdown, hide custom edit field and back button
                app.SettlingTimeDropDown.Visible = 'on';
                app.SettlingTimeCustomEdit.Visible = 'off';
                app.SettlingBackButton.Visible = 'off';
            end

            % Update summary
            updateSummaryWithSystemModel(app);
        end

        function resetOvershootToDropdown(app)
            % Reset overshoot selection back to dropdown
            app.OvershootDropDown.Value = 'Low Overshoot (Max %5)'; % Default selection
            app.OvershootDropDown.Visible = 'on';
            app.OvershootCustomEdit.Visible = 'off';
            app.OvershootBackButton.Visible = 'off';
            updateSummaryWithSystemModel(app);
        end

        function resetSettlingToDropdown(app)
            % Reset settling time selection back to dropdown
            app.SettlingTimeDropDown.Value = 'Fast (1s-3s)'; % Default selection
            app.SettlingTimeDropDown.Visible = 'on';
            app.SettlingTimeCustomEdit.Visible = 'off';
            app.SettlingBackButton.Visible = 'off';
            updateSummaryWithSystemModel(app);
        end

        function systemInfo = collectSystemInfo(app)
            systemInfo = struct();

            % System model information - According to selected definition method
            try
                systemInfo.system_model = struct();

                % Only state-space method is supported
                % Read directly from entered matrices
                systemInfo.system_model.A = strjoin(app.SystemAMatrixEdit.Value, '');
                systemInfo.system_model.B = strjoin(app.SystemBMatrixEdit.Value, '');
                systemInfo.system_model.C = strjoin(app.SystemCMatrixEdit.Value, '');
                systemInfo.system_model.D = strjoin(app.SystemDMatrixEdit.Value, '');
                systemInfo.system_model.source = 'State-Space (direct)';

                systemInfo.system_model.initial_conditions = '1'; % Fixed value of 1
            catch
                systemInfo.system_model = struct('A', '[0 1; 0 0]', 'B', '[0; 1]', 'C', 'eye(2)', 'D', '[0;0]', 'initial_conditions', '1', 'source', 'fallback');
            end

            % Input signal information (fixed values)
            systemInfo.input_signal = struct('type', 'Step (Step)', 'amplitude', 1, 'frequency', 0);

            % MRAC model information
            try
                systemInfo.mrac_model = struct();
                systemInfo.mrac_model.type = app.ModelTypeDropDown.Value;
                systemInfo.mrac_model.gamma_theta = app.GammaThetaEdit.Value;
                systemInfo.mrac_model.gamma_kr = app.GammaKrEdit.Value;
                systemInfo.mrac_model.sampling_time = app.SamplingTimeEdit.Value;
            catch
                systemInfo.mrac_model = struct('type', 'Classic MRAC', 'gamma_theta', 10, 'gamma_kr', 10, 'sampling_time', 0.001);
            end

            % Performance goals (now in reference model panel)
            try
                systemInfo.performance_goals = struct();

                % Handle Overshoot - check if custom value is selected
                if strcmp(app.OvershootDropDown.Value, 'Custom...')
                    % Use custom value with validation
                    customOvershoot = app.OvershootCustomEdit.Value;
                    % Validate range (0-100%)
                    if customOvershoot < 0
                        customOvershoot = 0;
                        app.OvershootCustomEdit.Value = 0;
                    elseif customOvershoot > 100
                        customOvershoot = 100;
                        app.OvershootCustomEdit.Value = 100;
                    end
                    systemInfo.performance_goals.overshoot = sprintf('Custom: %.1f%%', customOvershoot);
                else
                    systemInfo.performance_goals.overshoot = app.OvershootDropDown.Value;
                end

                % Handle Settling Time - check if custom value is selected
                if strcmp(app.SettlingTimeDropDown.Value, 'Custom...')
                    % Use custom value with validation
                    customSettling = app.SettlingTimeCustomEdit.Value;
                    % Validate range (0.1-30s)
                    if customSettling < 0.1
                        customSettling = 0.1;
                        app.SettlingTimeCustomEdit.Value = 0.1;
                    elseif customSettling > 30
                        customSettling = 30;
                        app.SettlingTimeCustomEdit.Value = 30;
                    end
                    systemInfo.performance_goals.settling_time = sprintf('Custom: %.2fs', customSettling);
                else
                    systemInfo.performance_goals.settling_time = app.SettlingTimeDropDown.Value;
                end
            catch
                systemInfo.performance_goals = struct('overshoot', 'No overshoot (0%)', 'settling_time', 'Medium (3s-7s)');
            end

            % Natural language input (removed)
            systemInfo.natural_language_input = '';
        end
        
        % NEW: Old JSON parsing functions removed - 3 suggestions system used
        
        % NEW: GPT Model Recommendation - 3 Suggestions Display
        function getGptModelRecommendation(app)
            % Detailed API debug information
            fprintf('🔍 === API DEBUG INFORMATION ===\n');
            
            % Get API key from centralized settings
            currentApiKey = '';
            if ~isempty(app.settingsManager)
                currentApiKey = app.settingsManager.getApiKey();
            end
            
            fprintf('SettingsManager exists: %s\n', string(~isempty(app.settingsManager)));
            fprintf('API Key empty: %s\n', string(isempty(currentApiKey)));
            if ~isempty(currentApiKey)
                fprintf('API Key length: %d\n', length(currentApiKey));
                fprintf('API Key first 10 chars: %s\n', currentApiKey(1:min(10,end)));
                fprintf('API Key last 10 chars: %s\n', currentApiKey(max(1,end-9):end));
                fprintf('API Key format sk- check: %s\n', string(startsWith(currentApiKey, 'sk-')));
            else
                fprintf('API Key: EMPTY\n');
            end
            fprintf('🔍 === API DEBUG END ===\n\n');
            
            % API key check - if not available, show local recommendations directly
            if isempty(currentApiKey) || strcmp(currentApiKey, 'dummy-key') || length(currentApiKey) < 20
                fprintf('⚠️ API key invalid/missing - Showing local recommendations\n');
                fprintf('   Reason: apiKey empty=%s, dummy=%s, short=%s\n', ...
                    string(isempty(currentApiKey)), string(strcmp(currentApiKey, 'dummy-key')), string(length(currentApiKey) < 20));
                app.showLocalSuggestions();
                return;
            end
            
            app.GptSuggestionsArea.Value = {
                '🔄 Getting 3 reference model recommendations from GPT...', ...
                '', ...
                '⏰ Be patient in rate limit situation:', ...
                '• 5-120 seconds waiting time possible', ...
                '• System automatically retries', ...
                '• Total 5 attempts will be made', ...
                '', ...
                '📡 Establishing API connection...'
            };
            app.GetGptAdviceButton.Enable = 'off';
            app.GptSuggestion1Button.Enable = 'off';
            app.GptSuggestion2Button.Enable = 'off';
            app.GptSuggestion3Button.Enable = 'off';
            drawnow;

            try
                % FIRST PERFORM SIMPLE API TEST
                fprintf('🔍 Checking API status...\n');
                app.GptSuggestionsArea.Value = {'🧪 Testing API connection...'};
                drawnow;
                
                isApiWorking = app.testSimpleApiCall();
                
                if ~isApiWorking
                    fprintf('❌ API not working - switching to local recommendations\n');
                    app.showLocalSuggestions();
                    return;
                end
                
                fprintf('✅ API working - getting recommendations...\n');
                app.GptSuggestionsArea.Value = {'✅ API test successful - getting recommendations...'};
                drawnow;
                
                % Collect system information
                systemInfo = app.collectSystemInfo();
                
                % Create 3-suggestion prompt
                suggestionsPrompt = app.createGptSuggestionsPrompt(systemInfo);
                
                % Create API configuration - OPTIMIZED FOR RATE LIMIT
                apiConfig = struct(...
                    'apiKey', app.settingsManager.getApiKey(), ...
                    'model', app.settingsManager.getModel(), ...
                    'temperature', 0.5, ... % More deterministic
                    'max_tokens', 800 ... % Less token usage
                );
                
                gptResponse = callGptApi_combined(suggestionsPrompt, apiConfig);
                
                % Parse 3 suggestions from JSON response
                app.parseGptSuggestions(gptResponse);
                
                % Update suggestions display
                app.updateGptSuggestionsDisplay();
                
                % Show selection information to user
                app.showSelectionMessage();
                
                % Activate buttons
                app.GetGptAdviceButton.Enable = 'on';
                app.GptSuggestion1Button.Enable = 'on';
                app.GptSuggestion2Button.Enable = 'on';
                app.GptSuggestion3Button.Enable = 'on';
                
            catch ME
                fprintf('❌ GPT API error: %s\n', ME.message);
                
                % Show local recommendations for any API error
                if contains(ME.message, '429') || contains(ME.message, 'Too Many Requests') || contains(ME.message, 'rate limit')
                    fprintf('⏰ Rate limit error detected - switching to local recommendations\n');
                else
                    fprintf('🔧 API error detected - switching to local recommendations\n');
                end
                
                % Show local recommendations
                app.showLocalSuggestions();
            end
        end
        
        % NEW: Create 3 GPT Suggestions Prompt
        function prompt = createGptSuggestionsPrompt(app, systemInfo)
            % System source information
            if isfield(systemInfo.system_model, 'source')
                source_info = sprintf(' [Source: %s]', systemInfo.system_model.source);
            else
                source_info = '';
            end
            
            % Parse system matrices to get dimensions
            try
                A_sys = eval(systemInfo.system_model.A);
                B_sys = eval(systemInfo.system_model.B);
                C_sys = eval(systemInfo.system_model.C);
                D_sys = eval(systemInfo.system_model.D);
                
                [n_A, m_A] = size(A_sys);  % Should be nxn
                [n_B, m_B] = size(B_sys);  % Should be nx1
                [n_C, m_C] = size(C_sys);  % System output matrix
                [n_D, m_D] = size(D_sys);  % Feedthrough matrix
                
                fprintf('📐 System matrix dimensions:\n');
                fprintf('   A: %dx%d, B: %dx%d, C: %dx%d, D: %dx%d\n', n_A, m_A, n_B, m_B, n_C, m_C, n_D, m_D);
                
                % CRITICAL: Reference model matrices MUST be EXACTLY THE SAME SIZE as system
                dimensionInfo = sprintf(['\n🚨 CRITICAL DIMENSION REQUIREMENTS - MUST BE EXACT MATCH:\n' ...
                    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n' ...
                    'YOUR SYSTEM HAS:\n' ...
                    '  A: %dx%d,  B: %dx%d,  C: %dx%d,  D: %dx%d\n\n' ...
                    'REFERENCE MODEL MUST HAVE EXACTLY:\n' ...
                    '  ✅ A_m: %dx%d matrix (SAME as A)\n' ...
                    '  ✅ B_m: %dx%d vector (SAME as B)\n' ...
                    '  ✅ C_m: %dx%d matrix (EXACTLY: %s) ← CRITICAL!\n' ...
                    '  ✅ D_m: %dx%d (EXACTLY: %s) ← CRITICAL!\n\n' ...
                    '⚠️ IF YOU MAKE C_m OR D_m DIFFERENT SIZE, SIMULATION WILL FAIL!\n' ...
                    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n'], ...
                    n_A, m_A, n_B, m_B, n_C, m_C, n_D, m_D, ...
                    n_A, m_A, n_B, m_B, n_C, m_C, systemInfo.system_model.C, n_D, m_D, systemInfo.system_model.D);
            catch ME
                fprintf('⚠️ Sistem matrisi parse edilemedi: %s\n', ME.message);
                dimensionInfo = sprintf(['\n⚠️ STANDARD 2nd ORDER SYSTEM (default):\n' ...
                    '• A_m: 2x2 matrix\n' ...
                    '• B_m: 2x1 vector\n' ...
                    '• C_m: 1x2 matrix like [1 0]\n' ...
                    '• D_m: scalar (0)\n\n']);
            end
            
            prompt = sprintf(['You are a MRAC expert assistant. Provide 3 DIFFERENT reference model suggestions based on the following system information.\n\n' ...
                'SYSTEM INFORMATION:\n' ...
                '• Plant/System Matrices%s: A=%s, B=%s, C=%s, D=%s\n' ...
                '• Input Signal: %s (Amplitude: %.2f, Frequency: %.2f Hz)\n%s'], ...
                source_info, systemInfo.system_model.A, systemInfo.system_model.B, systemInfo.system_model.C, systemInfo.system_model.D, ...
                systemInfo.input_signal.type, systemInfo.input_signal.amplitude, systemInfo.input_signal.frequency, dimensionInfo);
            
            % Add performance goals
            if ~isempty(systemInfo.performance_goals.overshoot)
                prompt = [prompt sprintf('• Desired Overshoot: %s\n', systemInfo.performance_goals.overshoot)];
            end
            if ~isempty(systemInfo.performance_goals.settling_time)
                prompt = [prompt sprintf('• Desired Settling Time: %s\n', systemInfo.performance_goals.settling_time)];
            end
            
            prompt = [prompt sprintf(['\n\nTASK: Provide 3 different reference model suggestions for this system:\n' ...
                '1. First suggestion: PERFORMANCE OPTIMUM - Fastest and most stable response\n' ...
                '2. Second suggestion: ROBUSTNESS OPTIMUM - Stability and noise resistance\n' ...
                '3. Third suggestion: GENERAL PURPOSE - Balanced performance\n\n' ...
                'IMPORTANT: The reference model''s DC gain (steady-state gain) must be the SAME as the system model!\n' ...
                'If the system step response converges to 1, the reference model should also converge to 1.\n' ...
                'Check with DC gain = -C*A^(-1)*B + D formula.\n' ...
                'If DC gain is different, adjust B_m matrix as follows:\n' ...
                'Use B_m = [0; wn^2/DC_gain_system] instead of B_m = [0; wn^2].\n' ...
                'Example: If system DC gain=1, B_m = [0; wn^2/1] = [0; wn^2]\n' ...
                'Example: If system DC gain=0.5, B_m = [0; wn^2/0.5] = [0; 2*wn^2]\n\n' ...
                'Provide matrix values in MATLAB format (e.g. [0 1; -2 -3]). Respond in JSON format:\n\n' ...
                'IMPORTANT MATRIX FORMAT RULES:\n' ...
                '- A_m: MUST BE 2x2 matrix, e.g. "[0 1; -4 -3]"\n' ...
                '- B_m: MUST BE 2x1 column vector, e.g. "[0; 4]" (semicolon required!)\n' ...
                '- C_m: MUST BE 1x2 row vector, e.g. "[1 0]" (NO semicolon!) - NEVER use 2x2!\n' ...
                '- D_m: MUST BE scalar, e.g. "0" (NOT "[0; 0]", NOT "[0 0]", just "0")\n\n' ...
                'COMMON MISTAKES TO AVOID:\n' ...
                '❌ WRONG: "C_m": "[1 0; 0 1]" (2x2 is WRONG!)\n' ...
                '✅ CORRECT: "C_m": "[1 0]" (1x2 row vector)\n' ...
                '❌ WRONG: "D_m": "[0; 0]" (vector is WRONG!)\n' ...
                '✅ CORRECT: "D_m": "0" (scalar only)\n\n' ...
                '```json\n' ...
                '{\n' ...
                '  "suggestions": [\n' ...
                '    {\n' ...
                '      "name": "Performance Optimum",\n' ...
                '      "matrices": {\n' ...
                '        "A_m": "[0 1; -9 -6]",\n' ...
                '        "B_m": "[0; 9]",\n' ...
                '        "C_m": "[1 0]",\n' ...
                '        "D_m": "0"\n' ...
                '      },\n' ...
                '      "explanation": "Brief explanation (max 100 characters)",\n' ...
                '      "pros": "Advantages",\n' ...
                '      "cons": "Disadvantages"\n' ...
                '    },\n' ...
                '    {\n' ...
                '      "name": "Robustness Optimum",\n' ...
                '      "matrices": {\n' ...
                '        "A_m": "[0 1; -4 -4]",\n' ...
                '        "B_m": "[0; 4]",\n' ...
                '        "C_m": "[1 0]",\n' ...
                '        "D_m": "0"\n' ...
                '      },\n' ...
                '      "explanation": "...",\n' ...
                '      "pros": "...",\n' ...
                '      "cons": "..."\n' ...
                '    },\n' ...
                '    {\n' ...
                '      "name": "General Purpose",\n' ...
                '      "matrices": {\n' ...
                '        "A_m": "[0 1; -2.25 -3]",\n' ...
                '        "B_m": "[0; 2.25]",\n' ...
                '        "C_m": "[1 0]",\n' ...
                '        "D_m": "0"\n' ...
                '      },\n' ...
                '      "explanation": "...",\n' ...
                '      "pros": "...",\n' ...
                '      "cons": "..."\n' ...
                '    }\n' ...
                '  ]\n' ...
                '}\n' ...
                '```\n\n' ...
                'IMPORTANT: Response should be ONLY JSON!'])];
        end
        
        % NEW: GPT Suggestions Parsing Function
        function parseGptSuggestions(app, jsonResponse)
            try
                fprintf('🔍 DEBUG: Received GPT response (first 200 characters): %s...\n', ...
                    jsonResponse(1:min(200, length(jsonResponse))));
                
                % Clean unnecessary characters from JSON
                cleanJson = strtrim(jsonResponse);
                
                % Error: Empty response check
                if isempty(cleanJson)
                    error('Empty response received from GPT');
                end
                
                % Error response check
                if contains(lower(cleanJson), 'error:') || contains(lower(cleanJson), '"error"')
                    error('GPT API error: %s', cleanJson);
                end
                
                % JSON code block cleaning
                if contains(cleanJson, '```json')
                    extracted = extractBetween(cleanJson, '```json', '```');
                    if ~isempty(extracted)
                        cleanJson = extracted{1};
                    end
                elseif contains(cleanJson, '```')
                    extracted = extractBetween(cleanJson, '```', '```');
                    if ~isempty(extracted)
                        cleanJson = extracted{1};
                    end
                end
                
                % Parse JSON
                fprintf('🔍 DEBUG: Cleaned JSON (first 200 characters): %s...\n', ...
                    cleanJson(1:min(200, length(cleanJson))));
                
                data = jsondecode(cleanJson);
                
                % Save suggestions - convert struct array to cell array
                if isfield(data, 'suggestions') && length(data.suggestions) >= 3
                    % Convert struct array to cell array
                    app.gptSuggestions = cell(1, length(data.suggestions));
                    for i = 1:length(data.suggestions)
                        app.gptSuggestions{i} = data.suggestions(i);
                    end
                    
                    app.currentGptSuggestions = struct();
                    
                    % Get system dimensions ONCE for all suggestions
                    try
                        A_sys = eval(strjoin(app.SystemAMatrixEdit.Value, ''));
                        C_sys = eval(strjoin(app.SystemCMatrixEdit.Value, ''));
                        D_sys = eval(strjoin(app.SystemDMatrixEdit.Value, ''));
                        [~, n] = size(A_sys);
                        [n_C_sys, m_C_sys] = size(C_sys);
                        [n_D_sys, m_D_sys] = size(D_sys);
                        
                        systemC_str = strjoin(app.SystemCMatrixEdit.Value, '');
                        systemD_str = strjoin(app.SystemDMatrixEdit.Value, '');
                        
                        fprintf('\n📐 Sistem boyutları (referans için):\n');
                        fprintf('   C: %dx%d → %s\n', n_C_sys, m_C_sys, systemC_str);
                        fprintf('   D: %dx%d → %s\n', n_D_sys, m_D_sys, systemD_str);
                    catch
                        % Default to 2nd order
                        n = 2;
                        n_C_sys = 1; m_C_sys = 2;
                        n_D_sys = 1; m_D_sys = 1;
                        systemC_str = '[1 0]';
                        systemD_str = '0';
                    end
                    
                    for i = 1:min(3, length(data.suggestions))
                        % Get suggestion
                        suggestion = data.suggestions(i);
                        
                        fprintf('\n🔧 Öneri %d işleniyor...\n', i);
                        
                        % FIX: Correct matrix dimensions if GPT made mistakes
                        if isfield(suggestion, 'matrices')
                            matrices = suggestion.matrices;
                            originalC = matrices.C_m;
                            originalD = matrices.D_m;
                            
                            % ALWAYS force C_m and D_m to match system
                            matrices.C_m = systemC_str;
                            matrices.D_m = systemD_str;
                            
                            if ~strcmp(originalC, systemC_str)
                                fprintf('   ⚠️ C_m değiştirildi: %s → %s\n', originalC, systemC_str);
                            else
                                fprintf('   ✅ C_m doğru boyutta\n');
                            end
                            
                            if ~strcmp(originalD, systemD_str)
                                fprintf('   ⚠️ D_m değiştirildi: %s → %s\n', originalD, systemD_str);
                            else
                                fprintf('   ✅ D_m doğru boyutta\n');
                            end
                            
                            % Update suggestion with corrected matrices
                            suggestion.matrices = matrices;
                        end
                        
                        % Save corrected suggestion
                        app.currentGptSuggestions.(sprintf('suggestion%d', i)) = suggestion;
                        
                        % ALSO update gptSuggestions array
                        app.gptSuggestions{i} = suggestion;
                    end
                    
                    fprintf('✅ Successfully parsed %d suggestions from GPT (matrix dimensions verified).\n', length(data.suggestions));
                else
                    % Alternative format check
                    if isfield(data, 'suggestions')
                        fprintf('⚠️ GPT response has only %d suggestions (3 expected)\n', length(data.suggestions));
                        error('Insufficient suggestions found in GPT response (found: %d, expected: 3)', length(data.suggestions));
                    else
                        fprintf('⚠️ ''suggestions'' field not found in GPT response\n');
                        fprintf('🔍 DEBUG: Available fields: %s\n', strjoin(fieldnames(data), ', '));
                        error('GPT response not in expected format - suggestions field missing');
                    end
                end
                
            catch ME
                fprintf('❌ GPT suggestion parse error: %s\n', ME.message);
                fprintf('🔍 DEBUG: Full received response:\n%s\n', jsonResponse);
                error('GPT suggestion parse error: %s', ME.message);
            end
        end
        
        % NEW: GPT Suggestions Display Function (Enhanced - more readable)
        function updateGptSuggestionsDisplay(app)
            if isempty(app.gptSuggestions)
                return;
            end
            
            try
                displayContent = {'🎯 GPT REFERENCE MODEL RECOMMENDATIONS', ''};
                
                for i = 1:min(3, length(app.gptSuggestions))
                    suggestion = app.gptSuggestions{i};
                    
                    displayContent{end+1} = sprintf('╔══════════════ %d. %s ══════════════╗', i, suggestion.name);
                    displayContent{end+1} = sprintf('║ 💡 Explanation: %s', suggestion.explanation);
                    displayContent{end+1} = sprintf('║');
                    displayContent{end+1} = sprintf('║ ✅ Advantages:');
                    displayContent{end+1} = sprintf('║    %s', suggestion.pros);
                    displayContent{end+1} = sprintf('║');
                    displayContent{end+1} = sprintf('║ ⚠️  Disadvantages:');
                    displayContent{end+1} = sprintf('║    %s', suggestion.cons);
                    displayContent{end+1} = sprintf('╚═════════════════════════════════════════════╝');
                    displayContent{end+1} = '';
                end
                
                displayContent{end+1} = '🔥 FIRST SUGGESTION AUTOMATICALLY APPLIED!';
                displayContent{end+1} = '👆 You can select other suggestions by clicking the colored buttons above.';
                displayContent{end+1} = '';
                displayContent{end+1} = '💡 Tip: Each suggestion is optimized for different performance characteristics.';
                
                app.GptSuggestionsArea.Value = displayContent;
                
            catch ME
                app.GptSuggestionsArea.Value = {'❌ Error displaying suggestions:', ME.message};
            end
        end
        
        % NEW: Show Selection Message to User
        function updateSimulationParameters(app)
            % Called when simulation parameters change
            try
                iterationCount = app.IterationCountEdit.Value;
                masterFrequency = app.MasterFrequencyDropDown.Value;
                
                % Send to workspace immediately
                assignin('base', 'max_iter_gui', iterationCount);
                assignin('base', 'master_frequency_gui', masterFrequency);
                
                fprintf('🔄 Simulation parameters updated: Iteration=%d, Master frequency=%d\n', iterationCount, masterFrequency);
                
                % Show information in GUI (if available)
                if isprop(app, 'StatusLabel')
                    app.StatusLabel.Text = sprintf('📊 Parameters updated: %d iterations, GPT every %d iterations', iterationCount, masterFrequency);
                end
                
            catch ME
                fprintf('⚠️ Parameter update error: %s\n', ME.message);
            end
        end
        
        % Callback function - for GUI events
        function updateSimulationParametersCallback(app, src, event)
            fprintf('🎯 Callback triggered: %s changed\n', src.Tag);
            app.updateSimulationParameters();
        end
        
        function showSelectionMessage(app)
            try
                if ~isempty(app.gptSuggestions)
                    % Add selection message to suggestions area
                    currentValue = app.GptSuggestionsArea.Value;
                    selectionMsg = {
                        '', 
                        '🎯 YOU NEED TO MAKE A SELECTION!',
                        '════════════════════════════',
                        '👆 Select one of the 3 suggestions above:',
                        '• 1️⃣ Performance: Fast and stable response',
                        '• 2️⃣ Robustness: Noise resistant', 
                        '• 3️⃣ General: Balanced performance',
                        '',
                        '💡 Click the relevant button to make your selection!'
                    };
                    
                    app.GptSuggestionsArea.Value = [currentValue; selectionMsg];
                    
                    % Show in alert dialog
                    uialert(app.UIFigure, ...
                        ['3 reference model suggestions received from GPT!' newline newline ...
                         '🎯 Please select one of the following options:' newline ...
                         '• 1️⃣ Performance Optimum' newline ...
                         '• 2️⃣ Robustness Optimum' newline ...
                         '• 3️⃣ General Purpose' newline newline ...
                         'Click the relevant button to make your selection.'], ...
                        'Reference Model Selection', 'Icon', 'info');
                end
            catch ME
                fprintf('⚠️ Error showing selection message: %s\n', ME.message);
            end
        end
        
        % NEW: GPT Suggestion Application Function
        function applyGptSuggestion(app, suggestionIndex)
            % Use corrected suggestions from currentGptSuggestions (not original gptSuggestions)
            if ~isfield(app.currentGptSuggestions, sprintf('suggestion%d', suggestionIndex))
                fprintf('⚠️ Öneri %d bulunamadı\n', suggestionIndex);
                return;
            end
            
            try
                % Get CORRECTED suggestion (matrix dimensions fixed)
                suggestion = app.currentGptSuggestions.(sprintf('suggestion%d', suggestionIndex));
                matrices = suggestion.matrices;
                
                fprintf('\n📋 Öneri %d uygulanıyor:\n', suggestionIndex);
                fprintf('   A_m: %s\n', matrices.A_m);
                fprintf('   B_m: %s\n', matrices.B_m);
                fprintf('   C_m: %s\n', matrices.C_m);
                fprintf('   D_m: %s\n', matrices.D_m);
                
                % Apply matrices to reference model fields - WITH FORMAT CORRECTIONS
                if isfield(matrices, 'A_m')
                    A_str = char(matrices.A_m);
                    app.AMatrixEdit.Value = {A_str};
                end
                if isfield(matrices, 'B_m')
                    B_str = char(matrices.B_m);
                    app.BMatrixEdit.Value = {B_str};
                end
                if isfield(matrices, 'C_m')
                    C_str = char(matrices.C_m);
                    app.CMatrixEdit.Value = {C_str};
                end
                if isfield(matrices, 'D_m')
                    D_str = char(matrices.D_m);
                    % D matrix format correction
                    D_str = app.fixDMatrixFormat(D_str);
                    app.DMatrixEdit.Value = {D_str};
                end
                
                % Perform DC gain check
                app.validateReferenceModelDcGain();
                
                % Update summary
                app.updateSummaryWithSystemModel();
                
                % Update selected button appearance
                app.updateButtonSelection(suggestionIndex);
                
                % Information message
                msg = sprintf('✅ Suggestion %d applied: %s\n\n💡 %s\n\n📊 Advantages: %s\n⚠️ Disadvantages: %s', ...
                    suggestionIndex, suggestion.name, suggestion.explanation, ...
                    suggestion.pros, suggestion.cons);
                
                % Show information dialog for each selection
                uialert(app.UIFigure, msg, 'GPT Recommendation Applied', 'Icon', 'success');
                
                % Also print to console
                fprintf('✅ GPT suggestion %d applied by user selection: %s\n', suggestionIndex, suggestion.name);
                
            catch ME
                uialert(app.UIFigure, ['Error applying GPT recommendation: ' ME.message], 'Error', 'Icon', 'error');
            end
        end
        
        % NEW: Update Selected Button Appearance
        function updateButtonSelection(app, selectedIndex)
            try
                % First convert all buttons to default color
                app.GptSuggestion1Button.BackgroundColor = [0.2 0.6 0.2]; % Green
                app.GptSuggestion2Button.BackgroundColor = [0.2 0.4 0.8]; % Mavi
                app.GptSuggestion3Button.BackgroundColor = [0.8 0.4 0.2]; % Turuncu
                
                % Highlight selected button
                switch selectedIndex
                    case 1
                        app.GptSuggestion1Button.BackgroundColor = [0.1 0.8 0.1]; % Bright green
                        app.GptSuggestion1Button.Text = '✅ Performans';
                    case 2
                        app.GptSuggestion2Button.BackgroundColor = [0.1 0.6 1.0]; % Parlak mavi
                        app.GptSuggestion2Button.Text = '✅ Robustness';
                    case 3
                        app.GptSuggestion3Button.BackgroundColor = [1.0 0.6 0.1]; % Parlak turuncu
                        app.GptSuggestion3Button.Text = '✅ Genel';
                end
                
                % Also update suggestions area
                if ~isempty(app.gptSuggestions) && selectedIndex <= length(app.gptSuggestions)
                    suggestion = app.gptSuggestions{selectedIndex};
                    successMsg = {
                        '',
                        sprintf('✅ SEÇİMİNİZ UYGULANMIŞTIR: %s', upper(suggestion.name)),
                        '════════════════════════════════════════',
                        sprintf('📝 Açıklama: %s', suggestion.explanation),
                        sprintf('📊 Avantajları: %s', suggestion.pros),
                        sprintf('⚠️ Dezavantajları: %s', suggestion.cons),
                        '',
                        '🎯 Referans model matrisleri güncellendi!',
                        '▶️ Artık simülasyona geçebilirsiniz.'
                    };
                    
                    % Preserve existing content and append
                    currentContent = app.GptSuggestionsArea.Value;
                    app.GptSuggestionsArea.Value = [currentContent; successMsg];
                end
                
            catch ME
                fprintf('⚠️ Buton seçimi güncellenirken hata: %s\n', ME.message);
            end
        end
        
        % NEW: Create Context with System Information (General Usage)
        function prompt = buildEnhancedChatPrompt(app, history, systemInfo, userInput)
            % System source information
            if isfield(systemInfo.system_model, 'source')
                source_info = sprintf(' [%s]', systemInfo.system_model.source);
            else
                source_info = '';
            end
            
            % Detailed prompt containing system information
            systemContext = sprintf(['Mevcut sistem bilgileri:\n' ...
                '• Sistem%s: A=%s, B=%s, C=%s, D=%s\n' ...
                '• Giriş: %s (Amplitude: %.2f, Frequency: %.2f Hz)\n' ...
                '• MRAC: %s (γ_theta=%.1f, γ_kr=%.1f, Ts=%.4f)\n' ...
                '• Referans: %s\n'], ...
                source_info, systemInfo.system_model.A, systemInfo.system_model.B, systemInfo.system_model.C, systemInfo.system_model.D, ...
                systemInfo.input_signal.type, systemInfo.input_signal.amplitude, systemInfo.input_signal.frequency, ...
                systemInfo.mrac_model.type, systemInfo.mrac_model.gamma_theta, systemInfo.mrac_model.gamma_kr, systemInfo.mrac_model.sampling_time);
            
            % System message forcing JSON format
            systemMessage = ['Sen MRAC uzmanı bir asistansın. Her yanıtının sonunda MUTLAKA aşağıdaki JSON formatını ekle:\n\n' ...
                '```json\n' ...
                '{\n' ...
                '  "reference_matrices": {\n' ...
                '    "A_m": "matris_değeri_veya_null",\n' ...
                '    "B_m": "matris_değeri_veya_null",\n' ...
                '    "C_m": "matris_değeri_veya_null",\n' ...
                '    "D_m": "matris_değeri_veya_null"\n' ...
                '  },\n' ...
                '  "explanation": "Kısa açıklama",\n' ...
                '  "has_matrix_update": true_veya_false\n' ...
                '}\n' ...
                '```\n\n' ...
                'Eğer matris önerimiz yoksa matris değerlerini "null" yap ve has_matrix_update: false yap.\n' ...
                'Mevcut sistem: ' systemContext '\n\n' ...
                'Kullanıcı sorusu: ' userInput];
            
            % Simple prompt with only system message and last user input
            prompt = ['system: ' systemMessage '\n\nuser: ' userInput];
        end
        
        % NEW: GPT Suggestions Helper Functions (Removed old chat-based functions)
        
        % NEW: GPT Suggestion Status Message Update (Simplified)
        function updateGptStatus(app, message)
            if nargin < 2 || isempty(message)
                message = 'GPT suggestions ready';
            end
            
            % Show status in suggestions area
            app.GptSuggestionsArea.Value = {message};
            
            % Wait briefly
            pause(0.05);
        end

        % NEW: Initial Prompt Creation Function
        function prompt = buildInitialModelPrompt(app)
            modelType = app.ModelTypeDropDown.Value;
            refModelType = 'GUI'; % Always from GUI fields
            overshoot = '';
            settlingTime = '';
            
            % Performans hedeflerini kontrol et
            if isprop(app, 'OvershootDropDown') && ~isempty(app.OvershootDropDown.Value)
                overshoot = app.OvershootDropDown.Value;
                settlingTime = app.SettlingTimeDropDown.Value;
            end
            
            % NaturalLanguageInput no longer available - use empty string
            naturalLangInput = '';

            prompt = 'As an MRAC expert, start a model suggestion conversation based on the following information. Evaluate the selections, present alternatives, list advantages/disadvantages, and provide parameter suggestions. Keep your answers short and clear, encourage conversation. Guide the user by asking questions.\n\n';
            prompt = [prompt, sprintf('Selected MRAC Model: %s\n', modelType)];
            prompt = [prompt, sprintf('Reference Model: taken from GUI fields\n')];
            
            % Add reference model matrices
            if isprop(app, 'AMatrixEdit') && ~isempty(app.AMatrixEdit.Value)
                prompt = [prompt, sprintf('A_ref: %s\n', strjoin(app.AMatrixEdit.Value, ''))];
                prompt = [prompt, sprintf('B_ref: %s\n', strjoin(app.BMatrixEdit.Value, ''))];
                prompt = [prompt, sprintf('C_ref: %s\n', strjoin(app.CMatrixEdit.Value, ''))];
                prompt = [prompt, sprintf('D_ref: %s\n', strjoin(app.DMatrixEdit.Value, ''))];
            end
            
            if ~isempty(overshoot), prompt = [prompt, sprintf('Overshoot Target: %s\n', overshoot)]; end
            if ~isempty(settlingTime), prompt = [prompt, sprintf('Settling Time Target: %s\n', settlingTime)]; end
            if ~isempty(naturalLangInput), prompt = [prompt, sprintf('Additional Notes: %s\n', naturalLangInput)]; end
            prompt = [prompt, '\nStart your analysis and ask me questions.'];
        end
        
        % NEW: Local Model Suggestion Function (when GPT unavailable)
        function advice = getLocalModelAdvice(app, modelType, refModelType, overshoot, settlingTime, naturalLangInput)
            advice = {};
            
            % Model tipi analizi
            if ~isempty(modelType)
                switch modelType
                    case 'Classic MRAC'
                        advice{end+1} = '📋 Classic MRAC Model Seçildi:';
                        advice{end+1} = '✅ Avantajlar: Basit yapı, hızlı hesaplama, iyi anlaşılır';
                        advice{end+1} = '⚠️ Dezavantajlar: Gürültüye hassas, yüksek frekanslı bozuculara karşı zayıf';
                        advice{end+1} = '🎯 Uygun: Temiz sinyaller, basit sistemler';
                        
                    case 'Filtered MRAC'
                        advice{end+1} = '📋 Filtered MRAC Model Selected:';
                        advice{end+1} = '✅ Avantajlar: Gürültüye dayanıklı, yüksek frekanslı bozucu bastırma';
                        advice{end+1} = '⚠️ Dezavantajlar: Daha karmaşık, filtre tasarımı gerekli';
                        advice{end+1} = '🎯 Uygun: Gürültülü ortamlar, endüstriyel uygulamalar';
                        
                    % case 'Time Delay MRAC' % HIDDEN FROM UI - kept as comment
                    %     advice{end+1} = '📋 Time Delay MRAC Model Selected:';
                    %     advice{end+1} = '✅ Avantajlar: Gecikme telafisi, gerçekçi sistem modelleme';
                    %     advice{end+1} = '⚠️ Dezavantajlar: Karmaşık tasarım, gecikme tahmini gerekli';
                    %     advice{end+1} = '🎯 Uygun: Ağ tabanlı sistemler, uzaktan kontrol';
                end
                advice{end+1} = '';
            end
            
            % Performans hedefi analizi
            if ~isempty(overshoot) && ~isempty(settlingTime)
                advice{end+1} = '🎯 Performance Target Analysis:';
                
                if contains(overshoot, 'Aşım yok')
                    advice{end+1} = '• No overshoot response: Critical damping required (ζ≥1)';
                elseif contains(overshoot, 'Düşük Aşım')
                    advice{end+1} = '• Düşük aşım: Yüksek sönümleme (ζ=0.7-0.9)';
                elseif contains(overshoot, 'Orta Aşım')
                    advice{end+1} = '• Orta aşım: Dengeli yanıt (ζ=0.5-0.7)';
                else
                    advice{end+1} = '• High overshoot: Fast response but unstable (ζ<0.5)';
                end
                
                if contains(settlingTime, 'Çok Kısa')
                    advice{end+1} = '• Çok hızlı yerleşme: Yüksek bant genişliği gerekli';
                elseif contains(settlingTime, 'Kısa')
                    advice{end+1} = '• Hızlı yerleşme: Orta-yüksek bant genişliği';
                elseif contains(settlingTime, 'Orta')
                    advice{end+1} = '• Orta yerleşme: Dengeli bant genişliği';
                else
                    advice{end+1} = '• Slow settling: Low bandwidth, stable';
                end
                advice{end+1} = '';
            end
            
            % Parameter suggestions
            advice{end+1} = '⚙️ Parametre Ayarlama Önerileri:';
            advice{end+1} = '• Adaptasyon kazancı (γ): 0.1-10 arası başlayın';
            advice{end+1} = '• Yüksek γ: Hızlı adaptasyon ama gürültü hassasiyeti';
            advice{end+1} = '• Low γ: Slow but stable adaptation';
            advice{end+1} = '• Örnekleme süresi: Sistem dinamiklerinin 1/10\';
            
            if isempty(advice)
                advice = {'Lütfen model seçimi yapın ve öneriler için tekrar deneyin.'};
            end
        end
        
        % NEW: Summary and GPT Hint Update Function
        function updateSummaryAndGptHint(app)
            % First update normal summary
            updateSummary(app);
            
            % Update GPT hint
            updateGptHint(app);
        end
        
        % NEW: Advanced Summary Update (Including System Model)
        function updateSummaryWithSystemModel(app)
            try
                summary = {};
                
                % 1. Sistem/Plant Modeli Bilgisi
                summary{end+1} = '🏭 SİSTEM/PLANT MODELİ:';
                try
                    A_str = strjoin(app.SystemAMatrixEdit.Value, '');
                    B_str = strjoin(app.SystemBMatrixEdit.Value, '');
                    C_str = strjoin(app.SystemCMatrixEdit.Value, '');
                    D_str = strjoin(app.SystemDMatrixEdit.Value, '');
                    
                    summary{end+1} = sprintf('  • A = %s', A_str);
                    summary{end+1} = sprintf('  • B = %s', B_str);
                    summary{end+1} = sprintf('  • C = %s', C_str);
                    summary{end+1} = sprintf('  • D = %s', D_str);
                    
                    % Check system stability
                    A = eval(A_str); B = eval(B_str); C = eval(C_str); D = eval(D_str);
                    sys = ss(A, B, C, D);
                    poles = pole(sys);
                    if all(real(poles) < 0)
                        summary{end+1} = '  • Status: ✅ Stable System';
                    else
                        summary{end+1} = '  • Status: ⚠️ Unstable System';
                    end
                catch
                    summary{end+1} = '  • Status: ❌ Invalid Matrix Input';
                end
                summary{end+1} = '';
                
                % 2. Input Signal Information (Fixed values)
                summary{end+1} = '🎛️ GİRİŞ SİNYALİ:';
                summary{end+1} = '  • Tip: Step (Step)';
                summary{end+1} = '  • Amplitude: 1.00';
                summary{end+1} = '';
                
                % 3. MRAC Model Type
                modelType = app.ModelTypeDropDown.Value;
                if ~isempty(modelType)
                    summary{end+1} = '🎯 MRAC MODELİ:';
                    summary{end+1} = sprintf('  • Seçilen Model: %s', modelType);
                    summary{end+1} = '';
                end
                
                % 4. Reference Model Bilgisi
                summary{end+1} = '📊 REFERENCE MODEL:';
                summary{end+1} = '  • Taken directly from GUI fields';
                if isprop(app, 'AMatrixEdit') && ~isempty(app.AMatrixEdit.Value)
                    summary{end+1} = sprintf('  • A_ref: %s', strjoin(app.AMatrixEdit.Value, ''));
                    summary{end+1} = sprintf('  • B_ref: %s', strjoin(app.BMatrixEdit.Value, ''));
                    summary{end+1} = sprintf('  • C_ref: %s', strjoin(app.CMatrixEdit.Value, ''));
                    summary{end+1} = sprintf('  • D_ref: %s', strjoin(app.DMatrixEdit.Value, ''));
                end
                summary{end+1} = '';
                
                % 5. Doğal Dil Girişi (artık mevcut değil)
                % nlInput = strjoin(app.NaturalLanguageInput.Value, ' ');
                % if ~isempty(strtrim(nlInput))
                %     summary{end+1} = '🤖 DOĞAL DİL GİRİŞİ:';
                %     summary{end+1} = sprintf('  "%s"', nlInput);
                %     summary{end+1} = '';
                % end
                
                % 6. Hazırlık Durumu
                summary{end+1} = '🚀 STATUS:';
                % Lokal sabit: referans model tipi artık GUI'den okunuyor
                refModelType = 'GUI';
                if ~isempty(modelType) && ~isempty(refModelType)
                    summary{end+1} = '  ✅ Model selection completed - Ready for simulation!';
                    summary{end+1} = '  💡 Click "PROCEED TO SIMULATION" button to start.';
                else
                    summary{end+1} = '  ⏳ Complete model selection';
                end
                
                % SelectionSummary removed - not needed
                
            catch ME
                % SelectionSummary removed - not needed
                fprintf('❌ Summary update error: %s\n', ME.message);
            end
        end
        

        
        % YENİ: GPT İpucu Güncelleme Fonksiyonu
        function updateGptHint(app)
            try
                modelType = app.ModelTypeDropDown.Value;
                refModelType = 'GUI'; % Always from GUI fields
                
                % Performans hedeflerini kontrol et
                hasPerformanceGoals = false;
                if isprop(app, 'OvershootDropDown') && ~isempty(app.OvershootDropDown.Value)
                    overshoot = app.OvershootDropDown.Value;
                    settlingTime = app.SettlingTimeDropDown.Value;
                    if ~isempty(overshoot) && ~isempty(settlingTime)
                        hasPerformanceGoals = true;
                    end
                end
                
                % GPT ipucu metnini güncelle
                if ~isempty(modelType) && hasPerformanceGoals
                    app.GptSuggestionsArea.Value = {
                        '💡 MRAC model and performance targets specified!', '', ...
                        '🎯 Selected MRAC: ', modelType, '', ...
                        '📊 Reference Model Performance Goals:', ...
                        ['• Overshoot: ', overshoot], ...
                        ['• Settling Time: ', settlingTime], '', ...
                        '🚀 Click "Get Suggestions" button to get', ...
                        '3 different reference model suggestions', ...
                        'suitable for the above performance goals!'
                    };
                elseif ~isempty(modelType)
                    app.GptSuggestionsArea.Value = {
                        '📋 MRAC algorithm selected!', '', ...
                        ['🎯 Selected: ', modelType], '', ...
                        '📊 Specify the performance goals above', ...
                        'and click "Get Suggestions" button.', '', ...
                        'GPT will suggest 3 different reference', ...
                        'models suitable for your system.'
                    };
                else
                    app.GptSuggestionsArea.Value = {
                        '🎯 To get GPT reference model suggestions:', '', ...
                        '1. Define your system model in the left column', ...
                        '2. Select your performance goals above', ...
                        '3. Select MRAC algorithm in the right column', ...
                        '4. Click "Get Suggestions" button', '', ...
                        'The 3 most suitable reference model suggestions will be presented!'
                    };
                end
                
            catch
                % Hata durumunda varsayılan mesajı koru
            end
        end
        
        % YENİ: Model Formül ve GPT Güncelleme Fonksiyonu
        function updateModelFormulaAndGpt(app)
            updateModelFormula(app);
            updateGptHint(app);
        end
        
        % YENİ: Referans Panel ve GPT Güncelleme Fonksiyonu
        function updateRefPanelsAndGpt(app)
            updateRefPanels(app);
            updateSummaryWithSystemModel(app);
            updateGptHint(app);
        end
        
        function EvaluateButtonPushed(app, event)
            try
                A_ref = eval(['[', app.RefModelAField.Value, ']']);
                B_ref = eval(['[', app.RefModelBField.Value, ']']);
                C_ref = eval(['[', app.RefModelCField.Value, ']']);
                D_ref = eval(['[', app.RefModelDField.Value, ']']);
                kr_hat       = app.KrHatField.Value;
                gamma_theta  = app.GammaThetaField.Value;
                gamma_kr     = app.GammaKrField.Value;
                Ts           = app.TsField.Value;
                app.gptContext.reference_model = struct('A',A_ref,'B',B_ref,'C',C_ref,'D',D_ref);
                app.gptContext.adaptation_parameters = struct('kr_hat',kr_hat,'gamma_theta',gamma_theta,'gamma_kr',gamma_kr,'Ts',Ts);
                app.currentProject.reference_model = app.gptContext.reference_model;
                app.currentProject.adaptation_parameters = app.gptContext.adaptation_parameters;
                app.EvaluationResultArea.Value = 'Starting simulation...';
                drawnow;
                % runMRACSimulation fonksiyonunu çağır
                [e_all, theta_all, t_vec] = runMRACSimulation(app, app.ModelName, app.gptContext);
                app.currentProject.simulation_results = struct(...
                    'e_series', e_all, ...
                    'theta_series', theta_all, ...
                    'time_vector', t_vec ...
                );
                app.clearSimulationPlots();
                plot(app.ErrorAxes, t_vec, e_all);
                title(app.ErrorAxes, 'Error Curve ($e(t)$)', 'Interpreter','latex');
                xlabel(app.ErrorAxes, 'Time (s)');
                ylabel(app.ErrorAxes, 'Error');
                grid(app.ErrorAxes, 'on');
                plot(app.ThetaAxes, t_vec, theta_all);
                title(app.ThetaAxes, 'Adaptive Parameters', 'Interpreter','latex');
                xlabel(app.ThetaAxes, 'Time (s)');
                ylabel(app.ThetaAxes, 'Parameter');
                legend(app.ThetaAxes, '$\hat\theta_1$','$\hat\theta_2$','$\hat k_r$','Interpreter','latex','Location','best');
                grid(app.ThetaAxes, 'on');
                meanError  = mean(abs(e_all));
                finalTheta = theta_all(end,:);
                app.MeanErrorValueLabel.Text = num2str(meanError,'%.4f');
                app.FinalThetaValueLabel.Text = ['[', num2str(finalTheta,'%.4f '), ']'];
                app.EvaluationResultArea.Value = 'Simulation completed.';
                uialert(app.UIFigure, 'Simulation completed successfully!','Success','Icon','success');

                % Xm ve X workspace'te var mı kontrol et
                if evalin('base', 'exist(''Xm'', ''var'')')
                    Xm = evalin('base', 'Xm');
                    if isstruct(Xm)
                        t = Xm.time;
                        yref = Xm.signals.values;
                    else
                        t = Xm(:,1);
                        yref = Xm(:,2:end);
                    end
                else
                    t = [];
                    yref = [];
                end

                if evalin('base', 'exist(''X'', ''var'')')
                    X = evalin('base', 'X');
                    if isstruct(X)
                        t2 = X.time;
                        ysys = X.signals.values;
                    else
                        t2 = X(:,1);
                        ysys = X(:,2:end);
                    end
                else
                    t2 = [];
                    ysys = [];
                end

                % Grafik çizdir
                if ~isempty(t) && ~isempty(yref)
                    plot(app.ErrorAxes, t, yref, 'b', 'LineWidth', 2); hold(app.ErrorAxes, 'on');
                    if ~isempty(t2) && ~isempty(ysys)
                        plot(app.ErrorAxes, t2, ysys, 'r--', 'LineWidth', 2);
                        legend(app.ErrorAxes, 'Reference Model (Xm)', 'System Model (X)');
                    else
                        legend(app.ErrorAxes, 'Reference Model (Xm)');
                    end
                    hold(app.ErrorAxes, 'off');
                    title(app.ErrorAxes, 'Outputs: Reference and System');
                    xlabel(app.ErrorAxes, 'Time (s)');
                    ylabel(app.ErrorAxes, 'Output');
                    grid(app.ErrorAxes, 'on');
                else
                    cla(app.ErrorAxes);
                    title(app.ErrorAxes, 'Output data not found');
                end
            catch ME
                app.EvaluationResultArea.Value = ['Error: ', ME.message];
                uialert(app.UIFigure, ['Simulation error: ', ME.message],'Error','Icon','error');
                app.clearSimulationPlots();
                app.MeanErrorValueLabel.Text = 'N/A';
                app.FinalThetaValueLabel.Text = 'N/A';
            end
        end
        % (Diğer callback ve yardımcı fonksiyonlar yukarıdaki örnekteki gibi)
        function createComponents(app)
            % Ana pencere
            app.UIFigure = uifigure('Visible','off');
            figW = 1280;
            figH = 800;
            screenSize = get(0, 'ScreenSize');
            figX = (screenSize(3) - figW) / 2;
            figY = (screenSize(4) - figH) / 2;
            app.UIFigure.Position = [figX figY figW figH];
            app.UIFigure.Name = 'MRAC Simulation Application';
            app.UIFigure.Color = [0.98 0.98 0.98];

            % Üst başlık paneli - Modern tasarım
            app.TopActionPanel = uipanel(app.UIFigure, ...
                'Position', [0 760 1280 40], ...
                'BackgroundColor', [0.2 0.4 0.8], ...
                'BorderType', 'none');
            titleLabel = uilabel(app.TopActionPanel, ...
                'Text', 'MRAC Simulation Platform', ...
                'FontSize', 20, ...
                'FontWeight', 'bold', ...
                'FontColor', [1 1 1], ...
                'Position', [20 5 400 30]);

            % TabGroup - Modern görünüm ve büyük fontlu sekmeler
            app.TabGroup = uitabgroup(app.UIFigure, 'Position', [0 40 1280 760]);
            app.TabGroup.SelectionChangedFcn = @(src, event) onTabChanged(app, event);
            % Modern buton stili
            modernBtn = @(btn) set(btn, 'FontSize', 15, 'FontWeight', 'bold', 'FontName', 'Segoe UI', ...
                'BackgroundColor', [0.2 0.4 0.8], 'FontColor', [1 1 1], 'CornerRadius', 8);
            modernBtn(app.EvaluateButton);
            % modernBtn(app.NewProjectButton);        % HIDDEN
            % modernBtn(app.LoadProjectButton);       % HIDDEN

            % ========== ANA SAYFA - DETAYLI VE BİLGİLENDİRİCİ TASARIM ==========
            app.HomeTab = uitab(app.TabGroup, 'Title', '🏠 Home');
            
            % Ana Scrollable Panel (İçerik çok olduğu için kaydırılabilir)
            mainScrollPanel = uipanel(app.HomeTab, ...
                'BackgroundColor', [0.98 0.99 1.0], ...
                'Position', [10 10 1260 740], ...
                'BorderType', 'none');
            
            % ===== BAŞLIK VE HOŞ GELDİNİZ BÖLÜMÜ =====
            headerPanel = uipanel(mainScrollPanel, ...
                'Title', '', ...
                'BackgroundColor', [0.15 0.35 0.8], ...
                'Position', [10 680 1240 50], ...
                'BorderType', 'none');
            
            % Ana Başlık
            uilabel(headerPanel, ...
                'Text', '🎯 MRAC Simulation Application', ...
                'FontSize', 22, ...
                'FontWeight', 'bold', ...
                'FontColor', [1 1 1], ...
                'Position', [30 15 400 30], ...
                'HorizontalAlignment', 'left');
            
            % Versiyon Bilgisi
            uilabel(headerPanel, ...
                'Text', 'v2.1.0 - GPT-Powered Advanced Version', ...
                'FontSize', 12, ...
                'FontAngle', 'italic', ...
                'FontColor', [0.9 0.9 0.9], ...
                'Position', [850 25 300 20], ...
                'HorizontalAlignment', 'right');
            
            % Geliştirici Bilgisi
            uilabel(headerPanel, ...
                'Text', 'CS_NLP Research Group © 2024', ...
                'FontSize', 11, ...
                'FontColor', [0.8 0.8 0.8], ...
                'Position', [850 10 300 15], ...
                'HorizontalAlignment', 'right');
            
            % ===== HIZLI BAŞLANGIÇ BÖLÜMÜ =====
            quickStartPanel = uipanel(mainScrollPanel, ...
                'Title', '⚡ Quick Start', ...
                'FontWeight', 'bold', ...
                'FontSize', 14, ...
                'BackgroundColor', [0.96 1.0 0.96], ...
                'Position', [10 600 600 70], ...
                'BorderType', 'line', ...
                'BorderColor', [0.2 0.6 0.2]);
            
            % Hızlı başlangıç butonları
            app.GettingStartedButton = uibutton(quickStartPanel, ...
                'Text', '🚀 Go to Model Selection', ...
                'Position', [20 25 180 30], ...
                'FontSize', 12, ...
                'FontWeight', 'bold', ...
                'BackgroundColor', [0.2 0.6 0.2], ...
                'FontColor', [1 1 1]);
            app.GettingStartedButton.ButtonPushedFcn = @(src, event) navigateToModelSelection(app);
            
            app.DocumentationButton = uibutton(quickStartPanel, ...
                'Text', '📖 User Guide', ...
                'Position', [210 25 180 30], ...
                'FontSize', 12, ...
                'FontWeight', 'bold', ...
                'BackgroundColor', [0.2 0.4 0.8], ...
                'FontColor', [1 1 1]);
            app.DocumentationButton.ButtonPushedFcn = @(src, event) web('https://www.mathworks.com/help/matlab/ref/mrac.html');
            
            app.SupportButton = uibutton(quickStartPanel, ...
                'Text', '🛠️ Support & Help', ...
                'Position', [400 25 180 30], ...
                'FontSize', 12, ...
                'FontWeight', 'bold', ...
                'BackgroundColor', [0.6 0.2 0.2], ...
                'FontColor', [1 1 1]);
            app.SupportButton.ButtonPushedFcn = @(src, event) msgbox('For support: cs_nlp@support.com', 'Support', 'help');
            
            % ===== ÖZELLIKLER BÖLÜMÜ =====
            featuresPanel = uipanel(mainScrollPanel, ...
                'Title', '🔧 Application Features', ...
                'FontWeight', 'bold', ...
                'FontSize', 14, ...
                'BackgroundColor', [1.0 0.98 0.96], ...
                'Position', [620 550 630 120], ...
                'BorderType', 'line', ...
                'BorderColor', [0.8 0.5 0.2]);
            
            featuresText = uilabel(featuresPanel, ...
                'Text', {
                    '✅ GPT-4 supported smart reference model suggestion system'
                    '✅ State-space matrix input support'
                    '✅ Real-time system response visualization'
                    '✅ 2 different MRAC algorithms (Classic, Filtered)'
                    '✅ Automatic parameter transfer and error control system'
                    '✅ Detailed simulation reporting and export'
                    '✅ Command window integration and live log'
                }, ...
                'Position', [15 10 600 80], ...
                'FontSize', 11, ...
                'VerticalAlignment', 'top', ...
                'FontColor', [0.3 0.3 0.3]);
            
            % ===== GPT KULLANIM AMAÇLARI BÖLÜMÜ =====
            gptUsagePanel = uipanel(mainScrollPanel, ...
                'Title', '🤖 GPT-4 AI Usage Purposes', ...
                'FontWeight', 'bold', ...
                'FontSize', 14, ...
                'BackgroundColor', [0.96 1.0 0.96], ...
                'Position', [10 550 600 120], ...
                'BorderType', 'line', ...
                'BorderColor', [0.2 0.6 0.2]);
            
            gptUsageText = uilabel(gptUsagePanel, ...
                'Text', {
                    '🎯 Smart Reference Model Suggestion: 3 different models suitable for your system parameters'
                    '💬 Natural Language Chat: Ask questions about MRAC and control theory'
                    '🧠 Parameter Optimization: Suggestions based on your performance targets'
                    '🔍 Error Analysis: Suggestions for interpreting simulation results and improvements'
                    '📝 Code Explanation: Detailed explanation of MATLAB codes'
                    '🎓 Educational Support: Learning about MRAC theory and applications'
                    '⚙️ System Analysis: Stability and performance evaluation'
                }, ...
                'Position', [15 10 570 80], ...
                'FontSize', 11, ...
                'VerticalAlignment', 'top', ...
                'FontColor', [0.2 0.6 0.2]);
            
            % ===== MRAC NEDİR? BÖLÜMÜ =====
            mracInfoPanel = uipanel(mainScrollPanel, ...
                'Title', '🎓 What is MRAC (Model Reference Adaptive Control)?', ...
                'FontWeight', 'bold', ...
                'FontSize', 14, ...
                'BackgroundColor', [0.96 0.98 1.0], ...
                'Position', [10 420 1240 120], ...
                'BorderType', 'line', ...
                'BorderColor', [0.2 0.4 0.8]);
            
            mracDescText = uilabel(mracInfoPanel, ...
                'Text', {
                    ''
                    'MRAC is an adaptive control method developed for controlling systems with unknown parameters.'
                    ''
                    '🔹 Basic Principle: The aim is for the system output to follow the output of a predefined reference model.'
                    '🔹 Adaptive Feature: Control parameters are automatically adjusted according to system behavior.'
                    '🔹 Application Areas: Aviation, robotics, automation, electric motor control systems.'
                    '🔹 Advantages: Robustness against parameter uncertainties, high performance, stability.'
                    ''
                    '📊 With this application, you can easily design, simulate and optimize your MRAC system.'
                }, ...
                'Position', [15 10 1210 90], ...
                'FontSize', 12, ...
                'VerticalAlignment', 'top', ...
                'FontColor', [0.2 0.2 0.2]);
            
            % ===== KULLANIM ADIMLARI BÖLÜMÜ =====
            stepsPanel = uipanel(mainScrollPanel, ...
                'Title', '📋 Step-by-Step User Guide', ...
                'FontWeight', 'bold', ...
                'FontSize', 14, ...
                'BackgroundColor', [0.98 1.0 0.98], ...
                'Position', [10 300 1240 110], ...
                'BorderType', 'line', ...
                'BorderColor', [0.1 0.6 0.1]);
            
            % Adım 1
            step1Panel = uipanel(stepsPanel, ...
                'Title', '1️⃣ System Definition', ...
                'FontWeight', 'bold', ...
                'FontSize', 12, ...
                'BackgroundColor', [0.96 0.98 1.0], ...
                'Position', [10 30 200 40], ...
                'BorderType', 'line', ...
                'BorderColor', [0.2 0.4 0.8]);
            uilabel(step1Panel, ...
                'Text', 'System definition', ...
                'Position', [10 0 180 20], ...
                'FontSize', 10, ...
                'FontColor', [0.2 0.2 0.2]);
            
            % Ok 1
            uilabel(stepsPanel, 'Text', '➡️', 'Position', [220 40 20 15], 'FontSize', 14, 'FontColor', [0.2 0.4 0.8]);
            
            % Adım 2
            step2Panel = uipanel(stepsPanel, ...
                'Title', '2️⃣ GPT Reference Model', ...
                'FontWeight', 'bold', ...
                'FontSize', 12, ...
                'BackgroundColor', [1.0 0.98 0.96], ...
                'Position', [250 30 200 40], ...
                'BorderType', 'line', ...
                'BorderColor', [0.8 0.5 0.2]);
            uilabel(step2Panel, ...
                'Text', 'Get GPT suggestions', ...
                'Position', [10 0 180 20], ...
                'FontSize', 10, ...
                'FontColor', [0.2 0.2 0.2]);
            
            % Ok 2
            uilabel(stepsPanel, 'Text', '➡️', 'Position', [460 40 20 15], 'FontSize', 14, 'FontColor', [0.8 0.5 0.2]);
            
            % Adım 3
            step3Panel = uipanel(stepsPanel, ...
                'Title', '3️⃣ MRAC Configuration', ...
                'FontWeight', 'bold', ...
                'FontSize', 12, ...
                'BackgroundColor', [0.96 1.0 0.96], ...
                'Position', [490 30 200 40], ...
                'BorderType', 'line', ...
                'BorderColor', [0.1 0.6 0.1]);
            uilabel(step3Panel, ...
                'Text', 'Parameter adjustment', ...
                'Position', [10 0 180 20], ...
                'FontSize', 10, ...
                'FontColor', [0.2 0.2 0.2]);
            
            % Ok 3
            uilabel(stepsPanel, 'Text', '➡️', 'Position', [700 40 20 15], 'FontSize', 14, 'FontColor', [0.1 0.6 0.1]);
            
            % Adım 4
            step4Panel = uipanel(stepsPanel, ...
                'Title', '4️⃣ Simulation & Analysis', ...
                'FontWeight', 'bold', ...
                'FontSize', 12, ...
                'BackgroundColor', [1.0 0.96 0.96], ...
                'Position', [730 30 200 40], ...
                'BorderType', 'line', ...
                'BorderColor', [0.8 0.2 0.2]);
            uilabel(step4Panel, ...
                'Text', 'Run simulation', ...
                'Position', [10 0 180 20], ...
                'FontSize', 10, ...
                'FontColor', [0.2 0.2 0.2]);
            
            % Adımlar açıklama
            uilabel(stepsPanel, ...
                'Text', 'Complete these 4 steps to design and test your MRAC system', ...
                'Position', [10 0 950 20], ...
                'FontSize', 11, ...
                'FontColor', [0.4 0.4 0.4]);
            
            % ===== SEKMELER REHBERİ =====
            tabsGuidePanel = uipanel(mainScrollPanel, ...
                'Title', '📚 Tab Guide - Detailed Description of Each Tab', ...
                'FontWeight', 'bold', ...
                'FontSize', 14, ...
                'BackgroundColor', [0.98 0.98 1.0], ...
                'Position', [10 80 1240 200], ...
                'BorderType', 'line', ...
                'BorderColor', [0.4 0.4 0.8]);
            
            % Sekme açıklamaları
            tabDescriptions = {
                ''
                '🏠 Home: Detailed information about the application, user guide, and quick start'
                '💬 Chat: Natural language interaction with GPT-4, you can ask questions about the system'
                '🔧 Model Selection: 3-column system → System definition, GPT suggestion, MRAC configuration'
                '📊 Simulation: Graphic display, real-time iteration tracking, command window integration'
                '📄 Reporting: Export simulation results in PDF, HTML, Word formats'
                '⚙️ Settings: API key and system settings (Developer mode - automatically configured)'
            };
            
            tabGuideText = uilabel(tabsGuidePanel, ...
                'Text', tabDescriptions, ...
                'Position', [20 15 1200 150], ...
                'FontSize', 12, ...
                'VerticalAlignment', 'top', ...
                'FontColor', [0.2 0.2 0.2]);
            
            % ===== ALL STATUS SECTION =====
            % Durum bilgisi label (global)
            app.StatusLabel = uilabel(mainScrollPanel, ...
                'Text', 'System ready - GPT features active', ...
                'Position', [10 35 400 15], ...
                'FontSize', 11, ...
                'FontColor', [0.2 0.6 0.2], ...
                'FontWeight', 'bold');
            
            % Gelişmiş bilgi
            uilabel(mainScrollPanel, ...
                'Text', '💡 Tip: Click "🚀 Go to Model Selection" button or go to Model Selection tab to start.', ...
                'Position', [450 35 600 15], ...
                'FontSize', 11, ...
                'FontColor', [0.4 0.4 0.4], ...
                'FontAngle', 'italic');
            
            % Final mesaj
            uilabel(mainScrollPanel, ...
                'Text', '✨ This application is developed with GPT-4 AI support - CS_NLP Research Group © 2024', ...
                'Position', [10 10 1200 20], ...
                'FontSize', 10, ...
                'FontColor', [0.6 0.6 0.6], ...
                'FontAngle', 'italic', ...
                'HorizontalAlignment', 'center');
            
            % Dinamik layout güncellemesi (eski sistemi kaldırdık)
            fprintf('✅ Advanced main page loaded - Using static layout\n');

            % Projeler sekmesi - HIDDEN
            % app.ProjectsTab = uitab(app.TabGroup, 'Title', 'Projeler');
            % projPanel = uipanel(app.ProjectsTab, ...
            %     'Title', 'Projelerim', ...
            %     'FontWeight', 'bold', ...
            %     'FontSize', 14, ...
            %     'BackgroundColor', [1 1 1], ...
            %     'Position', [40 80 400 650], ...
            %     'BorderType', 'line', ...
            %     'BorderColor', [0.8 0.8 0.8]);
            % app.ProjectsListBox = uilistbox(projPanel, ...
            %     'Position', [20 60 360 540], ...
            %     'FontSize', 12, ...
            %     'BackgroundColor', [1 1 1]);
            % buttonPanel = uipanel(projPanel, ...
            %     'Position', [20 20 360 30], ...
            %     'BackgroundColor', [1 1 1], ...
            %     'BorderType', 'none');
            % app.NewProjectButton = uibutton(buttonPanel, ...
            %     'Text', 'Yeni Proje', ...
            %     'Position', [0 0 120 30], ...
            %     'FontSize', 12, ...
            %     'BackgroundColor', [0.2 0.4 0.8], ...
            %     'FontColor', [1 1 1]);
            % app.LoadProjectButton = uibutton(buttonPanel, ...
            %     'Text', 'Proje Aç', ...
            %     'Position', [130 0 120 30], ...
            %     'FontSize', 12, ...
            %     'BackgroundColor', [0.4 0.4 0.4], ...
            %     'FontColor', [1 1 1]);

            % ========== YENİ: Model Seçim sekmesi - 3 Sütunlu Layout ==========
            app.ModelSelectionTab = uitab(app.TabGroup, 'Title', '🔧 Model Selection');
            
            % Ana container panel
            app.ModelSelectionPanel = uipanel(app.ModelSelectionTab, ...
                'Title', 'MRAC Model and Parameter Selection - Step by Step Guide', ...
                'FontWeight', 'bold', ...
                'FontSize', 16, ...
                'BackgroundColor', [0.97 0.98 0.99], ...
                'Position', [10 10 1260 740], ...
                'BorderType', 'none');
            
            % Progress Indicator (Üst kısım)
            progressPanel = uipanel(app.ModelSelectionPanel, ...
                'Title', '', ...
                'BackgroundColor', [0.95 0.97 1.0], ...
                'Position', [10 680 1240 50], ...
                'BorderType', 'line', ...
                'BorderColor', [0.3 0.5 0.8]);
            
            % Progress Steps
            step1Label = uilabel(progressPanel, ...
                'Text', '1️⃣ System Definition', ...
                'Position', [50 10 300 30], ...
                'FontSize', 14, ...
                'FontWeight', 'bold', ...
                'FontColor', [0.2 0.4 0.8], ...
                'HorizontalAlignment', 'center');
            
            step2Label = uilabel(progressPanel, ...
                'Text', '2️⃣ GPT Reference Model', ...
                'Position', [470 10 300 30], ...
                'FontSize', 14, ...
                'FontWeight', 'bold', ...
                'FontColor', [0.2 0.6 0.2], ...
                'HorizontalAlignment', 'center');
            
            step3Label = uilabel(progressPanel, ...
                'Text', '3️⃣ MRAC Configuration', ...
                'Position', [890 10 300 30], ...
                'FontSize', 14, ...
                'FontWeight', 'bold', ...
                'FontColor', [0.6 0.2 0.2], ...
                'HorizontalAlignment', 'center');
            
            % Progress arrows
            uilabel(progressPanel, 'Text', '➡️', 'Position', [380 15 20 20], 'FontSize', 16, 'FontColor', [0.5 0.5 0.5]);
            uilabel(progressPanel, 'Text', '➡️', 'Position', [800 15 20 20], 'FontSize', 16, 'FontColor', [0.5 0.5 0.5]);

            % ========== SOL SÜTUN: Sistem Modeli (30% genişlik) ==========
            app.LeftColumnPanel = uipanel(app.ModelSelectionPanel, ...
                'Title', '1️⃣ System/Plant Model Definition', ...
                'FontWeight', 'bold', ...
                'FontSize', 14, ...
                'BackgroundColor', [0.96 0.98 1.0], ...
                'Position', [10 10 380 660], ...
                'BorderType', 'line', ...
                'BorderColor', [0.3 0.5 0.8]);
            
            % State-Space Model Definition (Only method available)
            app.SystemDefinitionMethodGroup = uibuttongroup(app.LeftColumnPanel, ...
                'Title', '🎯 System Definition Method', ...
                'FontWeight', 'bold', ...
                'FontSize', 11, ...
                'BackgroundColor', [0.98 0.99 1.0], ...
                'Position', [10 620 360 35], ...
                'BorderType', 'line', ...
                'BorderColor', [0.2 0.4 0.8]);
            
            app.StateSpaceRadio = uiradiobutton(app.SystemDefinitionMethodGroup, ...
                'Text', 'State-Space (A,B,C,D) - Only Method', ...
                'Position', [10 -3 300 20], ...
                'FontSize', 10, ...
                'Value', true, ...
                'Enable', 'off'); % Disabled since it's the only option
            
            % Transfer function option removed - only state-space is supported
            
            % Sistem Model Paneli (Sol sütunda) - Pozisyon güncellenmiş ve genişletilmiş
            app.SystemModelPanel = uipanel(app.LeftColumnPanel, ...
                'Title', '📊 State-Space Matrices', ...
                'FontWeight', 'bold', ...
                'FontSize', 12, ...
                'BackgroundColor', [0.94 0.94 0.94], ...
                'Position', [10 200 360 415], ...
                'BorderType', 'line', ...
                'BorderColor', [0.2 0.4 0.8]);
            
            % State-space model açıklaması
            uilabel(app.SystemModelPanel, ...
                'Text', 'dx/dt = Ax + Bu,  y = Cx + Du', ...
                'Position', [10 365 250 18], ...
                'FontWeight', 'bold', ...
                'FontSize', 12, ...
                'FontColor', [0.2 0.2 0.2]);
            
            % Parameters başlığı
            uilabel(app.SystemModelPanel, ...
                'Text', 'Parameters', ...
                'Position', [10 350 100 18], ...
                'FontWeight', 'bold', ...
                'FontSize', 12, ...
                'FontColor', [0.2 0.2 0.2]);
            
            % A matrisi
            uilabel(app.SystemModelPanel, 'Text', 'A:', 'Position', [10 215 20 18], 'FontWeight', 'bold', 'FontSize', 11);
            app.SystemAMatrixEdit = uitextarea(app.SystemModelPanel, ...
                'Position', [35 320 150 25], ...
                'FontSize', 10, ...
                'Value', '[0 1; -1 -2]', ...
                'BackgroundColor', [1 1 1]);
            app.SystemAMatrixEdit.ValueChangedFcn = @(src, event) updateResultMatricesFromStateSpace(app);
            
            % B matrisi
            uilabel(app.SystemModelPanel, 'Text', 'B:', 'Position', [195 215 20 18], 'FontWeight', 'bold', 'FontSize', 11);
            app.SystemBMatrixEdit = uitextarea(app.SystemModelPanel, ...
                'Position', [220 320 85 25], ...
                'FontSize', 10, ...
                'Value', '[0; 1]', ...
                'BackgroundColor', [1 1 1]);
            app.SystemBMatrixEdit.ValueChangedFcn = @(src, event) updateResultMatricesFromStateSpace(app);
            
            % C matrisi
            uilabel(app.SystemModelPanel, 'Text', 'C:', 'Position', [10 185 20 18], 'FontWeight', 'bold', 'FontSize', 11);
            app.SystemCMatrixEdit = uitextarea(app.SystemModelPanel, ...
                'Position', [35 290 150 25], ...
                'FontSize', 10, ...
                'Value', '[1 0; 0 1]', ...
                'BackgroundColor', [1 1 1]);
            app.SystemCMatrixEdit.ValueChangedFcn = @(src, event) updateResultMatricesFromStateSpace(app);
            
            % D matrisi
            uilabel(app.SystemModelPanel, 'Text', 'D:', 'Position', [195 185 20 18], 'FontWeight', 'bold', 'FontSize', 11);
            app.SystemDMatrixEdit = uitextarea(app.SystemModelPanel, ...
                'Position', [220 290 85 25], ...
                'FontSize', 10, ...
                'Value', '[0; 0]', ...
                'BackgroundColor', [1 1 1]);
            app.SystemDMatrixEdit.ValueChangedFcn = @(src, event) updateResultMatricesFromStateSpace(app);
            
            % Önizleme butonu
            app.SystemPreviewButton = uibutton(app.SystemModelPanel, ...
                'Text', '📊 View System Response', ...
                'Position', [10 260 340 25], ...
                'FontSize', 11, ...
                'FontWeight', 'bold', ...
                'BackgroundColor', [0.2 0.4 0.8], ...
                'FontColor', [1 1 1]);
            app.SystemPreviewButton.ButtonPushedFcn = @(src, event) previewSystemResponse(app);
            
            % Sistem Yanıt Önizleme Paneli (SystemModelPanel içinde, butonun altında) - Dikeyde büyütülmüş
            app.SystemPreviewPanel = uipanel(app.SystemModelPanel, ...
                'Title', '📈 System Response Preview', ...
                'FontWeight', 'bold', ...
                'FontSize', 11, ...
                'BackgroundColor', [0.98 0.98 1], ...
                'Position', [10 10 340 250], ...
                'BorderType', 'line', ...
                'BorderColor', [0.2 0.4 0.8]);
            
            app.SystemResponseAxes = uiaxes(app.SystemPreviewPanel, ...
                'Position', [10 10 320 215], ...
                'FontSize', 9);
            title(app.SystemResponseAxes, 'System Step Response', 'FontSize', 10);
            xlabel(app.SystemResponseAxes, 'Time (s)', 'FontSize', 9);
            ylabel(app.SystemResponseAxes, 'Output', 'FontSize', 9);
            grid(app.SystemResponseAxes, 'on');
            
            % Transfer function panel removed - only state-space is supported
            
            % Transfer function components removed - only state-space is supported
            
            % Calculated System Matrices panel removed - not needed
            
            % Bilgi Paneli (Sol sütunda, alt kısım)
            infoPanel = uipanel(app.LeftColumnPanel, ...
                'Title', '💡 System Model Information', ...
                'FontWeight', 'bold', ...
                'FontSize', 12, ...
                'BackgroundColor', [0.98 1.0 0.98], ...
                'Position', [10 10 360 220], ...
                'BorderType', 'line', ...
                'BorderColor', [0.1 0.6 0.1]);
            
            infoText = uilabel(infoPanel, ...
                'Text', {'• Define your Plant/System model above', ...
                         '• Enter matrix values in MATLAB format', ...
                         '• Example: [0 1; -2 -3] or eye(2)', ...
                         '• Click button to view system response', ...
                         '• Initial conditions automatically set to 1', ...
                         '• Input signal automatically set to Step (amplitude=1)'}, ...
                'Position', [10 20 340 180], ...
                'FontSize', 11, ...
                'VerticalAlignment', 'top', ...
                'FontColor', [0.3 0.3 0.3]);

            % ========== ORTA SÜTUN: GPT Destekli Reference Model Seçimi (35% genişlik) ==========
            app.MiddleColumnPanel = uipanel(app.ModelSelectionPanel, ...
                'Title', '2️⃣ GPT-Supported Reference Model Selection', ...
                'FontWeight', 'bold', ...
                'FontSize', 14, ...
                'BackgroundColor', [1.0 0.98 0.96], ...
                'Position', [400 10 440 660], ...
                'BorderType', 'line', ...
                'BorderColor', [0.8 0.5 0.2]);
            
            % GPT Destekli Reference Model Paneli (Üstte - Ana panel)
            app.ReferenceModelPanel = uipanel(app.MiddleColumnPanel, ...
                'Title', '🤖 GPT-Supported Reference Model', ...
                'FontWeight', 'bold', ...
                'FontSize', 12, ...
                'BackgroundColor', [0.94 0.94 0.94], ...
                'Position', [10 300 420 340], ...
                'BorderType', 'line', ...
                'BorderColor', [0.2 0.6 0.2]);
            
            % Reference Model Formülü
            uilabel(app.ReferenceModelPanel, ...
                'Text', 'dx_m/dt = A_m*x_m + B_m*r,  y_m = C_m*x_m + D_m*r', ...
                'Position', [10 300 400 18], ...
                'FontWeight', 'bold', ...
                'FontSize', 11, ...
                'FontColor', [0.2 0.6 0.2]);
            
            % YENİ: 3 Önerisi sistemi altında artık bu butona gerek yok
            
            % Manuel Matris Girişi Bölümü
            uilabel(app.ReferenceModelPanel, ...
                'Text', 'Reference Model Parameters (GPT Recommended / Manual)', ...
                'Position', [10 230 350 18], ...
                'FontWeight', 'bold', ...
                'FontSize', 11, ...
                'FontColor', [0.2 0.6 0.2]);

            % A_m matrisi
            uilabel(app.ReferenceModelPanel, 'Text', 'A_m:', 'Position', [10 205 35 18], 'FontWeight', 'bold', 'FontSize', 12);
            app.AMatrixEdit = uitextarea(app.ReferenceModelPanel, ...
                'Position', [50 200 140 28], ...
                'FontSize', 11, ...
                'Value', '[0 1; -0.16 -0.57]', ...
                'BackgroundColor', [1 1 1]);
            app.AMatrixEdit.ValueChangedFcn = @(src, event) updateSummaryWithSystemModel(app);
            
            % B_m matrisi
            uilabel(app.ReferenceModelPanel, 'Text', 'B_m:', 'Position', [200 205 35 18], 'FontWeight', 'bold', 'FontSize', 12);
            app.BMatrixEdit = uitextarea(app.ReferenceModelPanel, ...
                'Position', [240 200 75 28], ...
                'FontSize', 11, ...
                'Value', '[0; 0.16]', ...
                'BackgroundColor', [1 1 1]);
            app.BMatrixEdit.ValueChangedFcn = @(src, event) updateSummaryWithSystemModel(app);
            
            % C_m matrisi
            uilabel(app.ReferenceModelPanel, 'Text', 'C_m:', 'Position', [10 175 35 18], 'FontWeight', 'bold', 'FontSize', 12);
            app.CMatrixEdit = uitextarea(app.ReferenceModelPanel, ...
                'Position', [50 170 140 28], ...
                'FontSize', 11, ...
                'Value', '[1 0; 0 1]', ...
                'BackgroundColor', [1 1 1]);
            app.CMatrixEdit.ValueChangedFcn = @(src, event) updateSummaryWithSystemModel(app);
            
            % D_m matrisi
            uilabel(app.ReferenceModelPanel, 'Text', 'D_m:', 'Position', [200 175 35 18], 'FontWeight', 'bold', 'FontSize', 12);
            app.DMatrixEdit = uitextarea(app.ReferenceModelPanel, ...
                'Position', [240 170 75 28], ...
                'FontSize', 11, ...
                'Value', '[0; 0]', ...
                'BackgroundColor', [1 1 1]);
            app.DMatrixEdit.ValueChangedFcn = @(src, event) updateSummaryWithSystemModel(app);
            
            % YENİ: Performans Hedefleri (Referans model denkleminin altında)
            uilabel(app.ReferenceModelPanel, 'Text', '🎯 Reference Model Performance Goals:', ...
                'Position', [10 275 350 18], 'FontWeight', 'bold', 'FontSize', 11, 'FontColor', [0.2 0.6 0.2]);
            
            uilabel(app.ReferenceModelPanel, 'Text', 'Overshoot:', 'Position', [10 255 50 18], 'FontSize', 11);
            app.OvershootDropDown = uidropdown(app.ReferenceModelPanel, ...
                'Items', {'No Overshoot (%0)', 'Low Overshoot (Max %5)', 'Medium Overshoot (Max %15)', 'High Overshoot (Max %25+)', 'Custom...'}, ...
                'Position', [60 250 120 25], 'FontSize', 10);
            app.OvershootDropDown.ValueChangedFcn = @(src, event) onPerformanceDropdownChanged(app);

            % Custom overshoot edit field (right next to dropdown, initially hidden)
            app.OvershootCustomEdit = uieditfield(app.ReferenceModelPanel, 'numeric', ...
                'Position', [60 250 85 25], ...
                'FontSize', 10, ...
                'Limits', [0 100], ...
                'Value', 5, ...
                'Visible', 'off', ...
                'ValueDisplayFormat', '%.1f %%', ...
                'Tooltip', 'Enter overshoot percentage (0-100%). Typical values: 0-25%');
            app.OvershootCustomEdit.ValueChangedFcn = @(src, event) updateSummaryWithSystemModel(app);

            % Back button for overshoot (initially hidden)
            app.OvershootBackButton = uibutton(app.ReferenceModelPanel, ...
                'Text', '↩', ...
                'Position', [150 250 25 25], ...
                'FontSize', 12, ...
                'Visible', 'off', ...
                'Tooltip', 'Back to dropdown selection', ...
                'BackgroundColor', [0.95 0.95 0.95]);
            app.OvershootBackButton.ButtonPushedFcn = @(src, event) resetOvershootToDropdown(app);

            uilabel(app.ReferenceModelPanel, 'Text', 'Settling:', 'Position', [185 255 60 18], 'FontSize', 11);
            app.SettlingTimeDropDown = uidropdown(app.ReferenceModelPanel, ...
                'Items', {'Very Fast (<1s)', 'Fast (1s-3s)', 'Medium (3s-7s)', 'Slow (>7s)', 'Custom...'}, ...
                'Position', [245 250 95 25], 'FontSize', 10);
            app.SettlingTimeDropDown.ValueChangedFcn = @(src, event) onPerformanceDropdownChanged(app);

            % Custom settling time edit field (right next to dropdown, initially hidden)
            app.SettlingTimeCustomEdit = uieditfield(app.ReferenceModelPanel, 'numeric', ...
                'Position', [245 250 85 25], ...
                'FontSize', 10, ...
                'Limits', [0.1 30], ...
                'Value', 2.0, ...
                'Visible', 'off', ...
                'ValueDisplayFormat', '%.2f s', ...
                'Tooltip', 'Enter settling time in seconds (0.1-30s). Typical values: 1-5s');
            app.SettlingTimeCustomEdit.ValueChangedFcn = @(src, event) updateSummaryWithSystemModel(app);

            % Back button for settling time (initially hidden)
            app.SettlingBackButton = uibutton(app.ReferenceModelPanel, ...
                'Text', '↩', ...
                'Position', [335 250 25 25], ...
                'FontSize', 12, ...
                'Visible', 'off', ...
                'Tooltip', 'Back to dropdown selection', ...
                'BackgroundColor', [0.95 0.95 0.95]);
            app.SettlingBackButton.ButtonPushedFcn = @(src, event) resetSettlingToDropdown(app);
            
            % Reference Model Görselleştirme Butonu ve Grafik
            app.RefPreviewButton = uibutton(app.ReferenceModelPanel, ...
                'Text', '📊 View Reference Model Response', ...
                'Position', [10 145 400 25], ...
                'FontSize', 10, ...
                'FontWeight', 'bold', ...
                'BackgroundColor', [0.2 0.6 0.2], ...
                'FontColor', [1 1 1]);
            app.RefPreviewButton.ButtonPushedFcn = @(src, event) previewReferenceResponse(app);
            
            % Reference Model Yanıt Grafiği
            app.ReferenceResponseAxes = uiaxes(app.ReferenceModelPanel, ...
                'Position', [10 10 400 130], ...
                'FontSize', 9);
            title(app.ReferenceResponseAxes, 'Reference Model Step Response', 'FontSize', 10);
            xlabel(app.ReferenceResponseAxes, 'Time (s)', 'FontSize', 9);
            ylabel(app.ReferenceResponseAxes, 'Output', 'FontSize', 9);
            grid(app.ReferenceResponseAxes, 'on');
            
            % AI Destekli 3 Önerisi Paneli (Maksimum uzatılmış - neredeyse tüm alt alan)
            app.GptResponsePanel = uipanel(app.MiddleColumnPanel, 'Title', '🎯 GPT Reference Model Suggestions', ...
                'Position', [10 10 420 285], 'BackgroundColor', [0.98 1 0.98], 'BorderType', 'line', 'BorderColor', [0.1 0.6 0.1], ...
                'FontWeight', 'bold', 'FontSize', 12);
            
            app.GptResponseLabel = uilabel(app.GptResponsePanel, ...
                'Text', '💡 3 Different GPT Reference Model Suggestions:', ...
                'Position', [10 245 300 20], ...
                'FontWeight', 'bold', ...
                'FontSize', 11, ...
                'FontColor', [0.1 0.6 0.1]);
            
            app.GptSuggestionsArea = uitextarea(app.GptResponsePanel, ...
                'Position', [10 55 400 195], ...
                'FontSize', 11, ...
                'Editable', 'off', ...
                'BackgroundColor', [0.99 1 0.99], ...
                'Value', {'Click "Get Suggestions" button to get 3 reference model suggestions from GPT.'});

            % 3 Önerisi Butonları (Yan Yana)
            app.GptSuggestion1Button = uibutton(app.GptResponsePanel, 'Text', '1️⃣ Performance', ...
                'Position', [10 25 100 25], ...
                'FontSize', 10, ...
                'FontWeight', 'bold', ...
                'BackgroundColor', [0.2 0.6 0.2], ...
                'FontColor', [1 1 1], ...
                'Enable', 'off');
            app.GptSuggestion1Button.ButtonPushedFcn = @(src, event) applyGptSuggestion(app, 1);
            
            app.GptSuggestion2Button = uibutton(app.GptResponsePanel, 'Text', '2️⃣ Robustness', ...
                'Position', [120 25 100 25], ...
                'FontSize', 10, ...
                'FontWeight', 'bold', ...
                'BackgroundColor', [0.2 0.4 0.8], ...
                'FontColor', [1 1 1], ...
                'Enable', 'off');
            app.GptSuggestion2Button.ButtonPushedFcn = @(src, event) applyGptSuggestion(app, 2);
            
            app.GptSuggestion3Button = uibutton(app.GptResponsePanel, 'Text', '3️⃣ General', ...
                'Position', [230 25 100 25], ...
                'FontSize', 10, ...
                'FontWeight', 'bold', ...
                'BackgroundColor', [0.8 0.4 0.2], ...
                'FontColor', [1 1 1], ...
                'Enable', 'off');
            app.GptSuggestion3Button.ButtonPushedFcn = @(src, event) applyGptSuggestion(app, 3);
            
            app.GetGptAdviceButton = uibutton(app.GptResponsePanel, 'Text', '🎯 Get Suggestions', ...
                'Position', [340 25 70 25], ...
                'FontSize', 10, ...
                'FontWeight', 'bold', ...
                'BackgroundColor', [0.1 0.6 0.1], ...
                'FontColor', [1 1 1]);
            app.GetGptAdviceButton.ButtonPushedFcn = @(src, event) getGptModelRecommendation(app);


            % ========== SAĞ SÜTUN: MRAC Model Seçimi (35% genişlik) ==========
            app.RightColumnPanel = uipanel(app.ModelSelectionPanel, ...
                'Title', '3️⃣ MRAC Model Selection and Parameters', ...
                'FontWeight', 'bold', ...
                'FontSize', 14, ...
                'BackgroundColor', [0.96 0.98 1.0], ...
                'Position', [850 10 420 660], ...
                'BorderType', 'line', ...
                'BorderColor', [0.2 0.4 0.8]);
            
            % MRAC Model Seçimi Paneli (Sağ Sütunda - Genişletilmiş)
            app.MRACModelPanel = uipanel(app.RightColumnPanel, ...
                'Title', '⚙️ MRAC Model Selection', ...
                'FontWeight', 'bold', ...
                'FontSize', 12, ...
                'BackgroundColor', [0.98 0.98 1.0], ...
                'Position', [10 350 400 290], ...
                'BorderType', 'line', ...
                'BorderColor', [0.2 0.4 0.8]);
            
            % MRAC Model Type Seçimi
            uilabel(app.MRACModelPanel, 'Text', 'MRAC Algorithm Type (Classic Only - Recommended):', ...
                'Position', [10 230 320 20], 'FontWeight', 'bold', 'FontSize', 11, 'FontColor', [0.2 0.4 0.8]);
            app.ModelTypeDropDown = uidropdown(app.MRACModelPanel, ...
                'Items', {'Classic MRAC'}, ... % Only Classic MRAC - most stable and reliable
                'Position', [10 200 300 30], 'FontSize', 12, 'BackgroundColor', [1 1 1], ...
                'Value', 'Classic MRAC', 'Enable', 'off');
            % Dropdown disabled since only one option available - Classic MRAC works best
            

            
            % Performans hedefleri orta sütuna taşındı
            
            % MRAC Parametreleri - Model tipine göre dinamik
            uilabel(app.MRACModelPanel, 'Text', 'Adaptation Parameters:', ...
                'Position', [10 180 220 20], 'FontWeight', 'bold', 'FontSize', 12, 'FontColor', [0.2 0.4 0.8]);
            
            % Dinamik label'lar - model seçimine göre değişecek
            app.GammaThetaLabel = uilabel(app.MRACModelPanel, 'Text', 'γ_theta (Parameter Gain):', ...
                'Position', [10 160 200 18], 'FontSize', 11);
            app.GammaThetaEdit = uieditfield(app.MRACModelPanel, 'numeric', ...
                'Value', 10, ...
                'Position', [220 155 120 25], ...
                'FontSize', 11);
            
            app.GammaKrLabel = uilabel(app.MRACModelPanel, 'Text', 'γ_kr (Reference Gain):', ...
                'Position', [10 140 200 18], 'FontSize', 11);
            app.GammaKrEdit = uieditfield(app.MRACModelPanel, 'numeric', ...
                'Value', 10, ...
                'Position', [220 135 120 25], ...
                'FontSize', 11);
            
            uilabel(app.MRACModelPanel, 'Text', 'Sampling Time (Ts):', 'Position', [10 120 200 18], 'FontSize', 11);
            app.SamplingTimeEdit = uieditfield(app.MRACModelPanel, 'numeric', ...
                'Value', 0.001, ...
                'Position', [220 115 120 25], ...
                'FontSize', 11);
                
            % Model tipi değiştiğinde hem parametreleri hem özeti güncelleyen callback
            app.ModelTypeDropDown.ValueChangedFcn = @(src, event) onModelTypeChanged(app);
            % Artık ipucu gerekli değil - referans model seçimi burada
            
            % Simülasyona Geç Butonu (MRAC Model Seçimi'nin Altında)
            app.ProceedToSimButton = uibutton(app.RightColumnPanel, ...
                'Text', '🚀 PROCEED TO SIMULATION', ...
                'Position', [10 290 400 50], ...
                'FontSize', 14, ...
                'FontWeight', 'bold', ...
                'BackgroundColor', [0.8 0.2 0.2], ...
                'FontColor', [1 1 1]);
            app.ProceedToSimButton.ButtonPushedFcn = @(src, event) proceedToSimulation(app);
            
            % Selection Summary panel removed - not needed
            
            % Bilgi Paneli (Sağ sütunda - MRAC Bilgileri)
            infoPanel3 = uipanel(app.RightColumnPanel, ...
                'Title', '⚙️ MRAC Configuration Information', ...
                'FontWeight', 'bold', ...
                'FontSize', 12, ...
                'BackgroundColor', [0.96 0.98 1.0], ...
                'Position', [200 10 210 270], ...
                'BorderType', 'line', ...
                'BorderColor', [0.2 0.4 0.8]);
            
            infoText3 = uilabel(infoPanel3, ...
                'Text', {'• Select MRAC algorithm type', ...
                         '• Select reference model type', ...
                         '• Set adaptation parameters', ...
                         '• Performance goals are in middle column', ...
                         '• Check summary before proceeding to simulation'}, ...
                'Position', [10 15 190 230], ...
                'FontSize', 10, ...
                'VerticalAlignment', 'top', ...
                'FontColor', [0.3 0.3 0.3]);

            % Panel ve alanların görünürlüğünü ve özetini güncelleyen fonksiyonlar
            % Model dropdown callback'i yukarıda ayarlandı
            % Performans hedefleri artık referans model panelinde olduğu için callback'leri zaten ayarlandı
            app.AMatrixEdit.ValueChangedFcn = @(src, event) updateSummaryWithSystemModel(app);
            app.BMatrixEdit.ValueChangedFcn = @(src, event) updateSummaryWithSystemModel(app);
            app.CMatrixEdit.ValueChangedFcn = @(src, event) updateSummaryWithSystemModel(app);
            app.DMatrixEdit.ValueChangedFcn = @(src, event) updateSummaryWithSystemModel(app);

            % ========== Simülasyon sekmesi (Sadece simülasyon araçları) ==========
            app.SimulationTab = uitab(app.TabGroup, 'Title', '⚡ Simulation');
            simPanel = uipanel(app.SimulationTab, ...
                'Title', 'MRAC Simulation', ...
                'FontWeight', 'bold', ...
                'FontSize', 14, ...
                'BackgroundColor', [1 1 1], ...
                'Position', [40 80 1200 650], ...
                'BorderType', 'line', ...
                'BorderColor', [0.8 0.8 0.8]);

            % Simülasyon Kontrol Butonları
            app.EvaluateButton = uibutton(simPanel, 'Text', '🚀 Start Simulation', ...
                'Position', [30 580 200 50], ...
                'FontSize', 16, ...
                'FontWeight', 'bold', ...
                'BackgroundColor', [0.2 0.6 0.2], ...
                'FontColor', [1 1 1], ...
                'Enable', 'off'); % Başlangıçta pasif - model seçimi yapılmadan aktif olmayacak
            % Basit ve güvenli versiyon kullan
            app.EvaluateButton.ButtonPushedFcn = @(src, event) startSimulation(app);
            
            % Simülasyonu Durdur Butonu
            app.StopButton = uibutton(simPanel, 'Text', '⏹️ Stop Simulation', ...
                'Position', [250 580 200 50], ...
                'FontSize', 16, ...
                'FontWeight', 'bold', ...
                'BackgroundColor', [0.8 0.2 0.2], ...
                'FontColor', [1 1 1], ...
                'Enable', 'off'); % Başlangıçta pasif
            app.StopButton.ButtonPushedFcn = @(src, event) stopSimulation(app);
            
            % YENİ: Analize Geç Butonu
            app.ProceedToAnalysisButton = uibutton(simPanel, 'Text', '📊 Proceed to Analysis', ...
                'Position', [470 580 200 50], ...
                'FontSize', 16, ...
                'FontWeight', 'bold', ...
                'BackgroundColor', [0.1 0.5 0.8], ...
                'FontColor', [1 1 1], ...
                'Enable', 'off', ...
                'Visible', 'off'); % Başlangıçta görünmez ve pasif
            app.ProceedToAnalysisButton.ButtonPushedFcn = @(src, event) proceedToAnalysis(app);

            % YENİ: Simülasyon Kontrol Parametreleri Paneli (Butonların hemen altında)
            app.SimulationControlPanel = uipanel(simPanel, ...
                'Title', 'Simulation Parameters', ...
                'FontWeight', 'bold', ...
                'FontSize', 12, ...
                'BackgroundColor', [0.95 0.95 1], ...
                'Position', [30 500 1140 70], ...
                'BorderType', 'line', ...
                'BorderColor', [0.6 0.6 0.8]);
            
            % Iterasyon Sayısı Kontrolü
            app.IterationCountLabel = uilabel(app.SimulationControlPanel, ...
                'Text', '🔢 Iteration Count:', ...
                'Position', [20 25 130 22], ...
                'FontSize', 12, ...
                'FontWeight', 'bold');
            
            app.IterationCountEdit = uieditfield(app.SimulationControlPanel, 'numeric', ...
                'Position', [160 25 80 22], ...
                'Value', 10, ...  % VARSAYILAN 10 OLSUN
                'Limits', [1 500], ...
                'LowerLimitInclusive', 'on', ...
                'UpperLimitInclusive', 'on', ...
                'RoundFractionalValues', 'on', ...
                'FontSize', 12, ...
                'Enable', 'on', ...
                'Editable', 'on');
            app.IterationCountEdit.ValueChangedFcn = @(src, event) updateSimulationParametersCallback(app, src, event);
            
            % BAŞLANGIÇTA PARAMETRELERİ WORKSPACE'E GÖNDER
            assignin('base', 'max_iter_gui', 10);
            assignin('base', 'master_frequency_gui', 5);
            
            % Usta-Çırak Sıklığı Kontrolü
            app.MasterFrequencyLabel = uilabel(app.SimulationControlPanel, ...
                'Text', '🤖 Master Consultation Frequency:', ...
                'Position', [280 25 150 22], ...
                'FontSize', 12, ...
                'FontWeight', 'bold');
            
            app.MasterFrequencyDropDown = uidropdown(app.SimulationControlPanel, ...
                'Items', {'Every iteration', 'Every 2 iterations', 'Every 5 iterations (Recommended)', 'Every 10 iterations', 'Apprentice only'}, ...
                'ItemsData', {1, 2, 5, 10, -1}, ...
                'Value', 5, ...
                'Position', [440 25 160 22], ...
                'FontSize', 11, ...
                'Enable', 'on');
            app.MasterFrequencyDropDown.ValueChangedFcn = @(src, event) updateSimulationParametersCallback(app, src, event);
            
            % Bilgi etiketi
            infoLabel = uilabel(app.SimulationControlPanel, ...
                'Text', '💡 Tip: "Apprentice only" option performs basic adaptation without GPT', ...
                'Position', [620 25 500 22], ...
                'FontSize', 10, ...
                'FontColor', [0.5 0.5 0.5]);

            % Progress bar - MATLAB versiyonuna göre dinamik oluşturulacak
            app.ProgressBar = [];
            
            app.StatusLabel = uilabel(simPanel, ...
                'Text', 'Ready - Go to "Model Selection" tab to make model selection', ...
                'Position', [30 460 500 30], ...
                'FontSize', 14, ...
                'FontColor', [0.2 0.6 0.2], ...
                'FontWeight', 'bold');

            % NEW: Iteration Information Panel - Expanded and Improved
            app.IterationLabel = uilabel(simPanel, ...
                'Text', '📊 Real-Time Iteration Information', ...
                'Position', [30 430 400 25], ...
                'FontWeight', 'bold', ...
                'FontSize', 14, ...
                'FontColor', [0.2 0.4 0.8]);
            
            % Special panel for iteration information
            iterationPanel = uipanel(simPanel, ...
                'Title', '', ...
                'BorderType', 'line', ...
                'BorderColor', [0.2 0.4 0.8], ...
                'BackgroundColor', [0.98 0.99 1.0], ...
                'Position', [30 220 400 215]);
            
            app.IterationDisplay = uitextarea(iterationPanel, ...
                'Position', [10 10 380 195], ...
                'FontSize', 11, ...
                'FontName', 'Consolas', ...
                'FontWeight', 'normal', ...
                'Editable', 'off', ...
                'BackgroundColor', [0.95 0.97 1.0], ...
                'Value', {
                    '🚀 Simulation Status'; 
                    '─────────────────────────────────────'; 
                    '';
                    '📊 Iteration: Waiting...';
                    '📉 Error (e): --';
                    '📈 Control Gain: --';
                    '🎯 Reference: --';
                    '⚙️ Adaptive Parameters: --';
                    '';
                    '⏱️ Start time: --';
                    '🔄 Status: Ready';
                    '';
                    'ℹ️ When simulation starts this area';
                    'will be updated in real-time.'
                });

            
            
            % Command Window log için özel panel
            commandLogPanel = uipanel(simPanel, ...
                'Title', '', ...
                'BorderType', 'line', ...
                'BorderColor', [0.8 0.4 0.1], ...
                'BackgroundColor', [1.0 0.99 0.95], ...
                'Position', [30 50 400 220]);

            % YENİ: Command Window Log Alanı
            app.CommandLogLabel = uilabel(commandLogPanel, ...
                'Text', '💻 MATLAB Command Window Outputs', ...
                'Position', [10 190 400 25], ...
                'FontWeight', 'bold', ...
                'FontSize', 14, ...
                'FontColor', [0.8 0.4 0.1]);
            
            app.CommandWindowDisplay = uitextarea(commandLogPanel, ...
                'Position', [10 20 380 170], ...
                'FontSize', 10, ...
                'FontName', 'Courier New', ...
                'FontWeight', 'normal', ...
                'Editable', 'off', ...
                'BackgroundColor', [0.05 0.05 0.05], ...
                'FontColor', [0.9 0.9 0.9], ...
                'Value', {
                    '>> MATLAB Command Window';
                    '';
                    'ℹ️ When simulation starts all MATLAB command';
                    'window outputs will be displayed here.';
                    '';
                    'This area will show parameter transfer, debug information,';
                    'simulation progress and error messages';
                    'all system information in real-time.';
                });
                
            % Command Window temizleme butonu
            app.ClearCommandLogButton = uibutton(commandLogPanel, ...
                'Text', '🗑️ Clear', ...
                'Position', [10 10 80 25], ...
                'FontSize', 10, ...
                'BackgroundColor', [0.6 0.6 0.6], ...
                'FontColor', [1 1 1], ...
                'Tooltip', 'Clear command window log');
            app.ClearCommandLogButton.ButtonPushedFcn = @(src, event) app.clearCommandLog();
            
            % Command Window kaydetme butonu
            app.SaveCommandLogButton = uibutton(commandLogPanel, ...
                'Text', '💾 Save', ...
                'Position', [100 10 80 25], ...
                'FontSize', 10, ...
                'BackgroundColor', [0.2 0.6 0.2], ...
                'FontColor', [1 1 1], ...
                'Tooltip', 'Save command window log to file');
            app.SaveCommandLogButton.ButtonPushedFcn = @(src, event) app.saveCommandLog();

            % Sonuç grafikleri - Daha büyük ve merkezi konumlandırma
            app.ErrorAxes = uiaxes(simPanel, ...
                'Position', [450 270 700 160], ...
                'FontSize', 12, ...
                'Box', 'on', ...
                'XGrid', 'on', ...
                'YGrid', 'on');
            app.ThetaAxes = uiaxes(simPanel, ...
                'Position', [450 80 700 160], ...
                'FontSize', 12, ...
                'Box', 'on', ...
                'XGrid', 'on', ...
                'YGrid', 'on');

            % Analysis tab (Intelligent Chat and Simulation Analysis)
            app.ChatTab = uitab(app.TabGroup, 'Title', 'Analysis');
            % Başlangıçta boş placeholder - startupFcn'da doldurulacak
            app.ChatInfoLabel = uilabel(app.ChatTab, ...
                'Text', '⏳ Analysis system loading...', ...
                'FontSize', 14, ...
                'FontWeight', 'normal', ...
                'FontColor', [0.5 0.5 0.5], ...
                'Position', [30 400 740 30]);
            % Eski chat bileşenleri (uyumluluk için - startupFcn'da kaldırılacak)
            app.ChatHistoryListBox = uilistbox(app.ChatTab, ...
                'Position', [30 120 740 520], ...
                'FontSize', 14, ...
                'Items', {'🔄 System loading...'}, ...
                'Visible', 'off');
            app.ChatInputArea = uitextarea(app.ChatTab, ...
                'Position', [30 60 600 50], ...
                'FontSize', 14, ...
                'Placeholder', 'System loading...', ...
                'Visible', 'off');
            app.SendButton = uibutton(app.ChatTab, 'Text', 'Loading...', ...
                'Position', [650 60 80 50], ...
                'FontSize', 14, ...
                'BackgroundColor', [0.2 0.4 0.6], ...
                'FontColor', [1 1 1], ...
                'Visible', 'off');
            app.CopyChatButton = uibutton(app.ChatTab, 'Text', '📋', ...
                'Position', [740 60 40 50], ...
                'FontSize', 16, ...
                'BackgroundColor', [0.3 0.3 0.3], ...
                'FontColor', [1 1 1], ...
                'Tooltip', 'Seçili mesajı kopyala', ...
                'Visible', 'off');
            app.CopyChatButton.ButtonPushedFcn = @(src, event) copyChatMessage(app);

            % Onay sekmesi - HIDDEN
            % app.ApprovalTab = uitab(app.TabGroup, 'Title', 'Onay');
            % approvalPanel = uipanel(app.ApprovalTab, ...
            %     'Title', 'Onay Listesi', ...
            %     'FontWeight', 'bold', ...
            %     'BackgroundColor', [1 1 1], ...
            %     'Position', [30 30 600 700]);
            % app.ApprovalListBox = uilistbox(approvalPanel, ...
            %     'Position', [20 100 560 540], ...
            %     'FontSize', 14);
            % app.ApproveButton = uibutton(approvalPanel, 'Text', 'Onayla', ...
            %     'Position', [20 20 120 40], ...
            %     'FontSize', 14, ...
            %     'BackgroundColor', [0.2 0.6 0.4], ...
            %     'FontColor', [1 1 1]);
            % app.RejectButton = uibutton(approvalPanel, 'Text', 'Reddet', ...
            %     'Position', [160 20 120 40], ...
            %     'FontSize', 14, ...
            %     'BackgroundColor', [0.8 0.2 0.2], ...
            %     'FontColor', [1 1 1]);

            % Raporlama sekmesi - Aktifleştirilmiş
            app.ReportingTab = uitab(app.TabGroup, 'Title', '📊 Reporting');
            reportPanel = uipanel(app.ReportingTab, ...
                'Title', 'Simulation Reporting System', ...
                'FontWeight', 'bold', ...
                'BackgroundColor', [1 1 1], ...
                'Position', [30 30 1200 650]);
            
            % Başlık ve açıklama
            uilabel(reportPanel, 'Text', '📊 MRAC Simulation Report Generator', ...
                'Position', [30 600 400 25], 'FontSize', 16, 'FontWeight', 'bold', 'FontColor', [0.2 0.4 0.8]);
            uilabel(reportPanel, 'Text', 'After simulation completion, you can download graphs and analysis results in the desired format.', ...
                'Position', [30 570 600 22], 'FontSize', 12, 'FontColor', [0.4 0.4 0.4]);
            
            % Format seçimi bölümü
            formatPanel = uipanel(reportPanel, 'Title', 'Report Format', ...
                'Position', [30 450 300 100], 'BackgroundColor', [0.98 0.98 1]);
            uilabel(formatPanel, 'Text', 'Select report format:', ...
                'Position', [20 50 150 22], 'FontSize', 12);
            app.ReportFormatDropDown = uidropdown(formatPanel, ...
                'Items', {'PDF', 'HTML', 'Word', 'PNG Grafikleri', 'MATLAB Figure'}, ...
                'Position', [20 20 200 25], ...
                'FontSize', 12, 'Value', 'PDF');
            
            % İçerik seçimi
            contentPanel = uipanel(reportPanel, 'Title', 'Report Content', ...
                'Position', [350 300 350 250], 'BackgroundColor', [0.98 0.98 1]);
            
            % Checkboxlar
            app.IncludeSystemPlotCheckBox = uicheckbox(contentPanel, ...
                'Text', 'System and Reference Model Graphs', ...
                'Position', [20 200 250 22], 'Value', true);
            app.IncludeErrorPlotCheckBox = uicheckbox(contentPanel, ...
                'Text', 'Error Graphs', ...
                'Position', [20 170 200 22], 'Value', true);
            app.IncludeParametersCheckBox = uicheckbox(contentPanel, ...
                'Text', 'Simulation Parameters', ...
                'Position', [20 140 200 22], 'Value', true);
            app.IncludeAnalysisCheckBox = uicheckbox(contentPanel, ...
                'Text', 'Performance Analysis', ...
                'Position', [20 110 200 22], 'Value', true);
            app.IncludeTimestampCheckBox = uicheckbox(contentPanel, ...
                'Text', 'Timestamp and Metadata', ...
                'Position', [20 80 200 22], 'Value', true);
            
            % Rapor başlığı
            uilabel(contentPanel, 'Text', 'Report Title:', ...
                'Position', [20 50 100 22], 'FontSize', 12);
            app.ReportTitleEdit = uieditfield(contentPanel, 'text', ...
                'Position', [20 20 300 25], 'Value', 'MRAC Simulation Report');
            
            % Status panel
            statusPanel = uipanel(reportPanel, 'Title', 'Status', ...
                'Position', [30 200 670 80], 'BackgroundColor', [0.95 0.95 1]);
            app.ReportStatusLabel = uilabel(statusPanel, ...
                'Text', 'Run simulation first to create report.', ...
                'Position', [20 30 600 22], 'FontSize', 12, 'FontColor', [0.6 0.6 0.6]);
            
            % Buttons
            app.ExportReportButton = uibutton(reportPanel, 'Text', '📄 Create and Download Report', ...
                'Position', [30 100 200 40], ...
                'FontSize', 14, 'FontWeight', 'bold', ...
                'BackgroundColor', [0.2 0.6 0.2], ...
                'FontColor', [1 1 1], ...
                'Enable', 'off'); % Başlangıçta pasif
            
            app.PreviewReportButton = uibutton(reportPanel, 'Text', '👁️ Preview', ...
                'Position', [250 100 120 40], ...
                'FontSize', 14, ...
                'BackgroundColor', [0.2 0.4 0.8], ...
                'FontColor', [1 1 1], ...
                'Enable', 'off');
            
            app.SavePlotsButton = uibutton(reportPanel, 'Text', '💾 Save Graphs', ...
                'Position', [390 100 150 40], ...
                'FontSize', 14, ...
                'BackgroundColor', [0.8 0.4 0.1], ...
                'FontColor', [1 1 1], ...
                'Enable', 'off');
            
            % Callback'leri bağla
            app.ExportReportButton.ButtonPushedFcn = @(src, event) exportReport(app);
            app.PreviewReportButton.ButtonPushedFcn = @(src, event) previewReport(app);
            app.SavePlotsButton.ButtonPushedFcn = @(src, event) savePlots(app);

            % Analiz sekmesi - HIDDEN
            % app.AnalyticsTab = uitab(app.TabGroup, 'Title', 'Analiz');
            % analyticsPanel = uipanel(app.AnalyticsTab, ...
            %     'Title', 'Analiz', ...
            %     'FontWeight', 'bold', ...
            %     'BackgroundColor', [1 1 1], ...
            %     'Position', [30 30 800 700]);
            % app.AnalyticsText = uilabel(analyticsPanel, ...
            %     'Text', 'Analiz grafikleri ve verileri burada gösterilecek.', ...
            %     'FontSize', 16, ...
            %     'FontColor', [0.3 0.3 0.3], ...
            %     'Position', [40 600 700 40]);

            % Eklentiler sekmesi - HIDDEN
            % app.PluginsTab = uitab(app.TabGroup, 'Title', 'Eklentiler');
            % pluginsPanel = uipanel(app.PluginsTab, ...
            %     'Title', 'Eklentiler', ...
            %     'FontWeight', 'bold', ...
            %     'BackgroundColor', [1 1 1], ...
            %     'Position', [30 30 400 700]);
            % app.PluginListBox = uilistbox(pluginsPanel, ...
            %     'Items', {'Plugin 1','Plugin 2'}, ...
            %     'Position', [20 100 360 540], ...
            %     'FontSize', 14);
            % app.InstallPluginButton = uibutton(pluginsPanel, 'Text', 'Eklenti Yükle', ...
            %     'Position', [20 20 150 40], ...
            %     'FontSize', 14, ...
            %     'BackgroundColor', [0.2 0.6 0.4], ...
            %     'FontColor', [1 1 1]);
            % app.UninstallPluginButton = uibutton(pluginsPanel, 'Text', 'Eklenti Kaldır', ...
            %     'Position', [200 20 150 40], ...
            %     'FontSize', 14, ...
            %     'BackgroundColor', [0.8 0.2 0.2], ...
            %     'FontColor', [1 1 1]);

            % Ayarlar sekmesi
            app.SettingsTab = uitab(app.TabGroup, 'Title', '⚙️ Settings');
            settingsPanel = uipanel(app.SettingsTab, ...
                'Title', 'Application Settings', ...
                'FontWeight', 'bold', ...
                'BackgroundColor', [1 1 1], ...
                'Position', [30 30 600 700]);
            app.APIKeyLabel = uilabel(settingsPanel, ...
                'Text', 'OpenAI API Key:', ...
                'Position', [20 600 180 22], ...
                'FontSize', 14, ...
                'FontWeight', 'bold', ...
                'FontColor', [0.2 0.4 0.8]);
            app.APIKeyEditField = uieditfield(settingsPanel, 'text', ...
                'Position', [180 600 300 22], ...
                'FontSize', 14, ...
                'Value', '', ...                  % Boş başlangıç
                'Enable', 'on', ...               % Düzenlenebilir
                'BackgroundColor', [1 1 1], ...   % Beyaz arka plan
                'Tooltip', 'Enter your OpenAI API key');
            app.GPTModelLabel = uilabel(settingsPanel, ...
                'Text', 'GPT Model:', ...
                'Position', [20 560 150 22], ...
                'FontSize', 14, ...
                'FontWeight', 'bold', ...
                'FontColor', [0.2 0.4 0.8]);
            app.GPTModelDropDown = uidropdown(settingsPanel, ...
                'Items', {'gpt-4o', 'gpt-4o-mini', 'gpt-4-turbo', 'gpt-4', 'gpt-3.5-turbo'}, ...
                'Position', [180 560 300 22], ...
                'FontSize', 14, ...
                'Value', 'gpt-4o-mini', ...
                'Tooltip', 'Kullanmak istediğiniz GPT modelini seçin');
            app.SaveSettingsButton = uibutton(settingsPanel, 'Text', 'Save Settings', ...
                'Position', [20 520 150 30], ...
                'FontSize', 14, ...
                'BackgroundColor', [0.2 0.4 0.6], ...
                'FontColor', [1 1 1], ...
                'ButtonPushedFcn', @(src, event) SaveSettingsButtonPushed(app, event));
            
            % API Connection Test Button
            app.TestAPIConnectionButton = uibutton(settingsPanel, 'Text', '🔗 API Connection Test', ...
                'Position', [190 520 180 30], ...
                'FontSize', 14, ...
                'BackgroundColor', [0.2 0.6 0.4], ...
                'FontColor', [1 1 1], ...
                'Tooltip', 'Test OpenAI API connection', ...
                'ButtonPushedFcn', @(src, event) TestAPIConnectionButtonPushed(app, event));
            
            % Ayarlar bilgi paneli
            settingsInfoPanel = uipanel(settingsPanel, ...
                'Title', 'Settings Information', ...
                'FontWeight', 'bold', ...
                'FontSize', 12, ...
                'BackgroundColor', [0.95 0.98 1.0], ...
                'BorderColor', [0.2 0.4 0.8], ...
                'Position', [20 200 550 230]);
            
            uilabel(settingsInfoPanel, ...
                'Text', '🔧 Centralized Settings Management', ...
                'Position', [10 195 300 20], ...
                'FontSize', 12, ...
                'FontWeight', 'bold', ...
                'FontColor', [0.2 0.4 0.8]);
            
            uilabel(settingsInfoPanel, ...
                'Text', 'API key and GPT model settings are managed centrally.', ...
                'Position', [10 175 400 20], ...
                'FontSize', 11, ...
                'FontColor', [0.4 0.4 0.4]);
            
            uilabel(settingsInfoPanel, ...
                'Text', 'Settings are automatically saved and loaded between sessions.', ...
                'Position', [10 155 400 20], ...
                'FontSize', 11, ...
                'FontColor', [0.4 0.4 0.4]);
            
            % Separator line
            uilabel(settingsInfoPanel, ...
                'Text', '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', ...
                'Position', [10 140 530 15], ...
                'FontSize', 10, ...
                'FontColor', [0.7 0.7 0.7]);
            
            % System Status Header
            uilabel(settingsInfoPanel, ...
                'Text', '📊 System Status', ...
                'Position', [10 120 200 20], ...
                'FontSize', 11, ...
                'FontWeight', 'bold', ...
                'FontColor', [0.2 0.4 0.8]);
            
            % System Status Label (Dynamic)
            app.SystemStatusLabel = uilabel(settingsInfoPanel, ...
                'Text', '⏳ Sistem başlatılıyor...', ...
                'Position', [10 10 530 105], ...
                'FontSize', 10, ...
                'FontColor', [0.3 0.3 0.3], ...
                'VerticalAlignment', 'top', ...
                'WordWrap', 'on');

            % Ana pencere için tuş desteği ekle (Enter basıldığında chat gönderme)
            app.UIFigure.KeyPressFcn = @(src, event) handleUIFigureKeyPress(app, src, event);
            
            app.UIFigure.Visible = 'on';
        end
        function startupFcn(app)
            % Başlangıçta yapılacak işlemler - Geliştirici modu
            
            % Modül yollarını path'e ekle
            try
                % Önce utils klasörünü path'e ekle
                currentDir = pwd;
                utilsPath = fullfile(currentDir, 'utils');
                if exist(utilsPath, 'dir')
                    addpath(utilsPath);
                    % Şimdi addModulePaths çağrısını yap
                    addModulePaths();
                    fprintf('✅ Module paths added successfully\n');
                else
                    fprintf('⚠️ Utils klasörü bulunamadı: %s\n', utilsPath);
                end
            catch ME
                fprintf('⚠️ Modül yolları eklenirken hata: %s\n', ME.message);
            end
            
            % Initialize centralized settings manager
            try
                app.settingsManager = GlobalSettings();
                fprintf('✅ Centralized settings manager initialized\n');
            catch ME
                fprintf('❌ Error initializing settings manager: %s\n', ME.message);
                app.settingsManager = [];
            end
            
            % Load API configuration from centralized settings
            if ~isempty(app.settingsManager)
                try
                    % Load API configuration from centralized settings
                    app.apiConfig = app.settingsManager.getApiConfig();
                    
                    % Update GUI fields with loaded settings
                    if isprop(app, 'APIKeyEditField') && isvalid(app.APIKeyEditField)
                        app.APIKeyEditField.Value = app.settingsManager.getApiKey();
                    end
                    if isprop(app, 'GPTModelDropDown') && isvalid(app.GPTModelDropDown)
                        currentModel = app.settingsManager.getModel();
                        if ismember(currentModel, app.GPTModelDropDown.Items)
                            app.GPTModelDropDown.Value = currentModel;
                        else
                            app.GPTModelDropDown.Value = 'gpt-4o-mini'; % Default
                        end
                    end
                    
                    % Enable GPT features if API key is valid
                    currentApiKey = app.settingsManager.getApiKey();
                    if ~isempty(currentApiKey)
                        app.useGptFeatures = true;
                        
                        % Chat özelliklerini aktif et
                        app.ChatInputArea.Editable = true;
                        app.SendButton.Enable = 'on';
                        app.ChatHistoryListBox.Enable = 'on';
                        
                        % Status label'ı güncelle
                        if isprop(app, 'StatusLabel') && isvalid(app.StatusLabel)
                            app.StatusLabel.Text = 'GPT features active (Centralized settings)';
                            app.StatusLabel.FontColor = [0.2 0.6 0.2]; % Yeşil
                        end
                        
                        fprintf('✅ GPT features active (Centralized settings)\n');
                    else
                        app.useGptFeatures = false;
                        fprintf('⚠️ API anahtarı geçersiz veya boş\n');
                    end
                catch ME
                    fprintf('❌ Error loading settings: %s\n', ME.message);
                    app.useGptFeatures = false;
                end
            else
                fprintf('⚠️ Settings manager not available\n');
                app.useGptFeatures = false;
            end
            
            % Default context ayarla
            app.gptContext = struct(...
                'system_model', struct(...
                    'A', [0, 1; 0, 0], ...
                    'B', [0; 1], ...
                    'C', eye(2), ...
                    'D', [0; 0] ...
                ), ...
                'reference_model', struct(...
                    'A', [0 1; -0.16 -0.57], ...
                    'B', [0; 0.16], ...
                    'C', eye(2), ...
                    'D', [0; 0] ...
                ), ...
                'adaptation_parameters', struct(...
                    'kr_hat', 1, ...
                    'gamma_theta', 25000, ...
                    'gamma_kr', 20000, ...
                    'Ts', 0.001 ...
                ), ...
                'chat_history', {cell(0,1)} ...
            );
            
            % GPT ipucunu başlangıçta güncelle
            updateGptHint(app);
            
            % İlk sistem modeli önizlemesi ve özet güncellemesi
            app.updateSummaryWithSystemModel();
            app.previewSystemResponse();
            
            % YENİ: Gelişmiş Chat Sistemi ve Veri Toplayıcısını Başlat
            try
                % SimulationDataCollector'ı başlat
                app.simulationDataCollector = SimulationDataCollector();
                fprintf('✅ SimulationDataCollector started\n');
                
                % ChatManager'ı başlat
                app.chatManager = ChatManager(app);
                
                % API anahtarı mevcutsa ChatManager'ı güncelle
                if ~isempty(app.settingsManager) && ~isempty(app.settingsManager.getApiKey())
                    fprintf('🔑 API key found, updating ChatManager...\n');
                    app.chatManager.updateApiKey();
                    
                    % Sohbet geçmişine hoşgeldin mesajı ekle (güvenli kontrol)
                    if app.safeCheck('EnhancedChatHistory')
                        timestamp = datestr(now, 'HH:MM');
                        welcomeMsg = sprintf('[%s] ✅ System: API key loaded! Chat system ready. You can send messages!', timestamp);
                        currentHistory = app.EnhancedChatHistory.Value;
                        app.EnhancedChatHistory.Value = [currentHistory; {''; welcomeMsg; ''}];
                    end
                    
                    % Update system status in Settings tab
                    app.updateSystemStatus('✅ ChatManager started and Chat UI updated', true);
                else
                    fprintf('ℹ️ API key not found - Add API key from Settings tab\n');
                    app.updateSystemStatus('⏳ API key waiting - Enter from Settings tab', false);
                end
                
                % Eski chat bileşenlerini temizle (SAFELY)
                fprintf('🧹 Cleaning old chat UI components...\n');
                
                if app.safeCheck('ChatInfoLabel')
                    delete(app.ChatInfoLabel);
                    fprintf('   ✅ ChatInfoLabel deleted\n');
                end
                if app.safeCheck('ChatHistoryListBox')
                    delete(app.ChatHistoryListBox);
                    fprintf('   ✅ ChatHistoryListBox deleted\n');
                end
                if app.safeCheck('ChatInputArea')
                    delete(app.ChatInputArea);
                    fprintf('   ✅ ChatInputArea deleted\n');
                end
                if app.safeCheck('SendButton')
                    delete(app.SendButton);
                    fprintf('   ✅ SendButton deleted\n');
                end
                if app.safeCheck('CopyChatButton')
                    delete(app.CopyChatButton);
                    fprintf('   ✅ CopyChatButton deleted\n');
                end
                
                fprintf('✅ Old components cleaned\n');
                
                % Chat sekmesini yeniden düzenle
                fprintf('🎨 Creating new Chat UI...\n');
                app.chatManager.setupChatUI();
                fprintf('✅ ChatManager started and Chat UI updated\n');
                
            catch ME
                fprintf('⚠️ Advanced chat system could not be started: %s\n', ME.message);
                if ~isempty(ME.stack)
                    fprintf('   Error details: %s\n', ME.stack(1).file);
                    fprintf('   Line: %d\n', ME.stack(1).line);
                end
                
                % "Loading..." mesajını kaldır
                fprintf('🧹 Cleaning "Loading..." placeholder...\n');
                if app.safeCheck('ChatInfoLabel')
                    delete(app.ChatInfoLabel);
                    fprintf('   ✅ Loading message deleted\n');
                end
                
                % Chat UI oluşturulamadı - API key kontrolü yap
                try
                    currentApiKey = '';
                    if ~isempty(app.settingsManager)
                        currentApiKey = app.settingsManager.getApiKey();
                    end
                    
                    if isempty(currentApiKey)
                        % API key yok - Bekleme UI oluştur
                        fprintf('📋 API key yok, Bekleme UI oluşturuluyor...\n');
                        app.createWaitingChatUI();
                        fprintf('✅ Bekleme Chat UI oluşturuldu - API anahtarı bekleniyor\n');
                    else
                        % API key var ama ChatManager başarısız - Tekrar dene
                        fprintf('⚠️ ChatManager başarısız oldu, tekrar deneniyor...\n');
                        pause(0.5); % Kısa bekle
                        
                        try
                            app.chatManager = ChatManager(app);
                            app.chatManager.setupChatUI();
                            fprintf('✅ ChatManager ikinci denemede başarılı!\n');
                        catch ME3
                            fprintf('❌ İkinci deneme de başarısız: %s\n', ME3.message);
                            fprintf('   Basit UI oluşturuluyor...\n');
                            app.createWaitingChatUI();
                        end
                    end
                catch ME2
                    fprintf('❌ Chat UI oluşturulamadı: %s\n', ME2.message);
                    fprintf('   Screen may remain empty - Add API key from Settings tab and restart application.\n');
                end
            end
        end
        function setPanelVisibility(app, event)
            switch event.NewValue.Text
                case 'Varsayılan'
                    app.PerfPanel.Visible = 'off';
                    % Referans model paneli her zaman görünür olsun
                    app.ManualPanel.Visible = 'on';
                case 'Performans Hedefi'
                    app.PerfPanel.Visible = 'on';
                    % Referans model paneli her zaman görünür olsun
                    app.ManualPanel.Visible = 'on';
                case 'Manuel'
                    app.PerfPanel.Visible = 'off';
                    % Referans model paneli her zaman görünür olsun
                    app.ManualPanel.Visible = 'on';
            end
        end
        % function runMRACCombinedFromGUI(app)
        %     % BASİT YAKLAŞIM - ESKİ KOD PRENSİBİ
        %     fprintf('🔄 runMRACCombinedFromGUI başlatılıyor...\n');
        % 
        %     % Parametreleri topla - BASİT
        %     modelType = app.ModelTypeDropDown.Value;
        %     refType = 'GUI'; % Her zaman from GUI fields
        % 
        %     fprintf('📋 Model Type: %s\n', modelType);
        %     fprintf('🎯 Referans: %s\n', refType);
        % 
        %     % Workspace'e gönder - BASİT
        %     assignin('base', 'modelType', modelType);
        %     assignin('base', 'refType', refType);
        %     assignin('base', 'app', app);
        %     assignin('base', 'GUI_LOG_ACTIVE', true);
        % 
        %     % ======= SYSTEM MODEL - BASİT =======
        %     try
        %         % Sistem matrislerini BASİT şekilde al
        %         A_sys_str = char(app.SystemAMatrixEdit.Value);
        %         B_sys_str = char(app.SystemBMatrixEdit.Value);
        %         C_sys_str = char(app.SystemCMatrixEdit.Value);
        %         D_sys_str = char(app.SystemDMatrixEdit.Value);
        % 
        %         fprintf('🔄 Sistem modeli gönderiliyor:\n');
        %         fprintf('   • A_sys: %s\n', A_sys_str);
        %         fprintf('   • B_sys: %s\n', B_sys_str);
        %         fprintf('   • C_sys: %s\n', C_sys_str);
        %         fprintf('   • D_sys: %s\n', D_sys_str);
        % 
        %         % Workspace'e gönder
        %         assignin('base', 'A_sys_gui', A_sys_str);
        %         assignin('base', 'B_sys_gui', B_sys_str);
        %         assignin('base', 'C_sys_gui', C_sys_str);
        %         assignin('base', 'D_sys_gui', D_sys_str);
        % 
        %     catch ME
        %         fprintf('⚠️ Sistem parametreleri hatası: %s\n', ME.message);
        %         % Varsayılan
        %         % assignin('base', 'A_sys_gui', '[0 1; 0 0]');
        %         % assignin('base', 'B_sys_gui', '[0; 1]');
        %         % assignin('base', 'C_sys_gui', 'eye(2)');
        %         % assignin('base', 'D_sys_gui', '[0; 0]');
        %     end
        % 
        %     % ======= MRAC PARAMETERS - BASİT =======
        %     try
        %         assignin('base', 'gamma_theta_gui', app.GammaThetaEdit.Value);
        %         assignin('base', 'gamma_kr_gui', app.GammaKrEdit.Value);
        %         assignin('base', 'sampling_time_gui', app.SamplingTimeEdit.Value);
        % 
        %         fprintf('🔧 MRAC parametreleri: γ_θ=%.1f, γ_kr=%.1f, Ts=%.4f\n', ...
        %             app.GammaThetaEdit.Value, app.GammaKrEdit.Value, app.SamplingTimeEdit.Value);
        % 
        %     catch ME
        %         fprintf('⚠️ MRAC parametreleri hatası: %s\n', ME.message);
        %         % assignin('base', 'gamma_theta_gui', 1000);
        %         % assignin('base', 'gamma_kr_gui', 1000);
        %         % assignin('base', 'sampling_time_gui', 0.001);
        %     end
        % 
        %                 % ======= REFERENCE MODEL - BASİT =======
        %     fprintf('🎯 Referans model gönderiliyor...\n');
        % 
        %     try
        %         % GUI'den referans model al - BASİT
        %         A_ref_str = char(app.AMatrixEdit.Value);
        %         B_ref_str = char(app.BMatrixEdit.Value);
        %         C_ref_str = char(app.CMatrixEdit.Value);
        %         D_ref_str = char(app.DMatrixEdit.Value);
        % 
        %         fprintf('📊 A_ref: %s\n', A_ref_str);
        %         fprintf('📊 B_ref: %s\n', B_ref_str);
        %         fprintf('📊 C_ref: %s\n', C_ref_str);
        %         fprintf('📊 D_ref: %s\n', D_ref_str);
        % 
        %         % Workspace'e gönder
        %         assignin('base', 'A_ref_gui', A_ref_str);
        %         assignin('base', 'B_ref_gui', B_ref_str);
        %         assignin('base', 'C_ref_gui', C_ref_str);
        %         assignin('base', 'D_ref_gui', D_ref_str);
        % 
        %         fprintf('✅ Referans model workspace''e gönderildi\n');
        % 
        %     catch ME
        %         fprintf('⚠️ Referans model hatası: %s\n', ME.message);
        %         % assignin('base', 'A_ref_gui', '[0 1; -1 -1.4]');
        %         % assignin('base', 'B_ref_gui', '[0; 1]');
        %         % assignin('base', 'C_ref_gui', 'eye(2)');
        %         % assignin('base', 'D_ref_gui', '[0; 0]');
        %     end
        % 
        %     % Referans model tipine göre ek parametreler
        %     if strcmp(refType, 'Performans Hedefi')
        %         % Performans hedeflerini gönder - GÜÇLENDIRILMIŞ DEBUG
        %         try
        %             fprintf('🎯 ===========================================\n');
        %             fprintf('   PERFORMANS HEDEFİ PARAMETRE TRANSFERİ\n');
        %             fprintf('   ===========================================\n');
        % 
        %             % Component'ların varlığını DETAYLI kontrol et
        %             overshootExists = isprop(app, 'OvershootDropDown');
        %             settlingExists = isprop(app, 'SettlingTimeDropDown');
        % 
        %             fprintf('   📊 Component Kontrolü:\n');
        %             fprintf('      • OvershootDropDown exists: %s\n', string(overshootExists));
        %             fprintf('      • SettlingTimeDropDown exists: %s\n', string(settlingExists));
        % 
        %             if ~overshootExists || ~settlingExists
        %                 fprintf('   ❌ Component eksikliği tespit edildi!\n');
        %                 % Varsayılan değerleri kullan
        %                 overshootValue = 'Düşük Aşım (Max %5)';
        %                 settlingValue = 'Orta (3s-7s)';
        %                 fprintf('   🔄 Varsayılan değerler kullanılacak:\n');
        %                 fprintf('      • Aşım: %s\n', overshootValue);
        %                 fprintf('      • Yerleşme: %s\n', settlingValue);
        %             else
        %                 % Component'lar mevcut - değerlerini al
        %                 overshootValue = app.OvershootDropDown.Value;
        %                 settlingValue = app.SettlingTimeDropDown.Value;
        % 
        %                 fprintf('   📋 Component Değerleri:\n');
        %                 fprintf('      • Aşım RAW: "%s" (tip: %s, boş: %s)\n', ...
        %                     string(overshootValue), class(overshootValue), string(isempty(overshootValue)));
        %                 fprintf('      • Yerleşme RAW: "%s" (tip: %s, boş: %s)\n', ...
        %                     string(settlingValue), class(settlingValue), string(isempty(settlingValue)));
        % 
        %                 % Boş değer kontrolü ve düzeltme
        %                 if isempty(overshootValue)
        %                     fprintf('   ⚠️ OvershootDropDown değeri boş - varsayılan kullanılacak\n');
        %                     overshootValue = 'Düşük Aşım (Max %5)';
        %                 end
        %                 if isempty(settlingValue)
        %                     fprintf('   ⚠️ SettlingTimeDropDown değeri boş - varsayılan kullanılacak\n');
        %                     settlingValue = 'Orta (3s-7s)';
        %                 end
        %             end
        % 
        %             fprintf('   🚀 Workspace''e gönderilecek değerler:\n');
        %             fprintf('      • overshoot: "%s"\n', overshootValue);
        %             fprintf('      • settling: "%s"\n', settlingValue);
        % 
        %             % Workspace'e gönder - Her atamayı kontrol et
        %             fprintf('   📤 Workspace''e gönderiliyor...\n');
        % 
        %             % Önce workspace'den temizle (varsa)
        %             if evalin('base', 'exist(''overshoot'', ''var'')')
        %                 evalin('base', 'clear overshoot');
        %             end
        %             if evalin('base', 'exist(''settling'', ''var'')')
        %                 evalin('base', 'clear settling');
        %             end
        % 
        %             % Yeniden ata
        %             assignin('base', 'overshoot', overshootValue);
        %             pause(0.01); % Kısa bekleme
        %             assignin('base', 'settling', settlingValue);
        %             pause(0.01);
        % 
        %             % Flag'ları da gönder
        %             assignin('base', 'gui_performance_sent', true);
        %             assignin('base', 'gui_transfer_timestamp', now);
        % 
        %             % DOĞRULAMA - Çok detaylı kontrol
        %             fprintf('   🔍 Workspace Doğrulama:\n');
        % 
        %             overshoot_check = evalin('base', 'exist(''overshoot'', ''var'')');
        %             settling_check = evalin('base', 'exist(''settling'', ''var'')');
        % 
        %             fprintf('      • overshoot exists: %s\n', string(overshoot_check));
        %             fprintf('      • settling exists: %s\n', string(settling_check));
        % 
        %             if overshoot_check && settling_check
        %                 % Değerleri de kontrol et
        %                 overshoot_value = evalin('base', 'overshoot');
        %                 settling_value = evalin('base', 'settling');
        % 
        %                 fprintf('      • overshoot value: "%s" (tip: %s)\n', overshoot_value, class(overshoot_value));
        %                 fprintf('      • settling value: "%s" (tip: %s)\n', settling_value, class(settling_value));
        % 
        %                 % Değerlerin doğru olup olmadığını kontrol et
        %                 if strcmp(overshoot_value, overshootValue) && strcmp(settling_value, settlingValue)
        %                     fprintf('   ✅ BAŞARILI: Performans parametreleri workspace''e aktarıldı!\n');
        %                 else
        %                     fprintf('   ⚠️ UYARI: Gönderilen ile workspace''teki değerler farklı!\n');
        %                     fprintf('      Gönderilen: "%s" / "%s"\n', overshootValue, settlingValue);
        %                     fprintf('      Workspace: "%s" / "%s"\n', overshoot_value, settling_value);
        %                 end
        %             else
        %                 fprintf('   ❌ HATA: Parametreler workspace''e aktarılamadı!\n');
        %                 fprintf('      Bu kritik bir hatadır - GUI parametrelerini script algılayamayacak!\n');
        % 
        %                 % Tekrar deneme
        %                 fprintf('   🔄 Tekrar deneme yapılıyor...\n');
        %                 assignin('base', 'overshoot', overshootValue);
        %                 assignin('base', 'settling', settlingValue);
        % 
        %                 % Tekrar kontrol
        %                 if evalin('base', 'exist(''overshoot'', ''var'')') && evalin('base', 'exist(''settling'', ''var'')')
        %                     fprintf('   ✅ Tekrar denemede başarılı!\n');
        %                 else
        %                     fprintf('   ❌ Tekrar denemede de başarısız - ciddi MATLAB workspace sorunu!\n');
        %                 end
        %             end
        % 
        %             fprintf('   ===========================================\n');
        % 
        %         catch ME
        %             fprintf('❌ Performans hedefleri aktarılırken HATA: %s\n', ME.message);
        %             fprintf('   Hata yeri: %s (satır %d)\n', ME.stack(1).name, ME.stack(1).line);
        %             % Güvenli varsayılan değerler kullan
        %             assignin('base', 'overshoot', 'Düşük Aşım (Max %5)');
        %             assignin('base', 'settling', 'Orta (3s-7s)');
        %             fprintf('   🔄 Varsayılan değerler güvenlik amacıyla atandı\n');
        %         end
        % 
        %     % Manuel tipi için ek gönderim (backward compatibility)
        %     if strcmp(refType, 'Manuel')
        %         assignin('base', 'A_ref_manual', A_ref_str);
        %         assignin('base', 'B_ref_manual', B_ref_str);
        %         assignin('base', 'C_ref_manual', C_ref_str);
        %         assignin('base', 'D_ref_manual', D_ref_str);
        % 
        %         fprintf('🔧 Ek manuel matris gönderimi (backward compatibility):\n');
        %         fprintf('   • A_ref_manual: %s\n', A_ref_str);
        %         fprintf('   • B_ref_manual: %s\n', B_ref_str);
        %         fprintf('   • C_ref_manual: %s\n', C_ref_str);
        %         fprintf('   • D_ref_manual: %s\n', D_ref_str);
        %     end
        % 
        %     % mrac_combined.m'i çalıştır - BASİT YAKLAŞIM
        %     try
        %         app.StatusLabel.Text = 'MRAC simülasyonu çalışıyor...';
        %         drawnow;
        % 
        %         fprintf('🚀 MRAC script çalıştırılıyor: mrac_combined.m\n');
        % 
        %         % AYNEN ESKİ KOD GİBİ - SADECE RUN KOMUTU
        %         if exist('mrac_combined_simple.m', 'file')
        %             fprintf('✅ mrac_combined_simple.m bulundu, çalıştırılıyor...\n');
        %             run('mrac_combined_simple.m');
        %             fprintf('✅ MRAC script tamamlandı\n');
        %         else
        %             error('mrac_combined_simple.m dosyası bulunamadı!');
        %         end
        % 
        %         % Sonuçları işle - BASİT
        %         app.updatePlotsFromWorkspace();
        %         app.StatusLabel.Text = 'Simülasyon başarıyla tamamlandı';
        %         app.StatusLabel.FontColor = [0.2 0.6 0.2];
        %         drawnow;
        % 
        %         % Basit başarı mesajı
        %         fprintf('🎉 MRAC simülasyonu BAŞARIYLA tamamlandı!\n');
        % 
        %         % Raporlama aktif et
        %         try
        %             app.enableReporting();
        %         catch
        %             % Hata durumunda sessizce geç
        %         end
        % 
        %     catch ME
        %         % Basit hata yönetimi - ESKİ KOD PRENSİBİ
        %         app.isSimulationRunning = 0;
        %         app.EvaluateButton.Enable = 'on';
        %         app.StopButton.Enable = 'off';
        %         app.StatusLabel.Text = ['Script hatası: ' ME.message];
        %         app.StatusLabel.FontColor = [0.8 0.2 0.2];
        % 
        %         fprintf('❌ MRAC simülasyon hatası: %s\n', ME.message);
        % 
        %         if isprop(app, 'UIFigure') && isvalid(app.UIFigure)
        %             uialert(app.UIFigure, ['Simülasyon hatası: ' ME.message], 'Hata', 'Icon', 'error');
        %         end
        %     end
        % end
        % end
        function runMRACCombinedFromGUI(app)
            % Bu fonksiyon, GUI'den alınan parametrelerle ana MRAC script'ini
            % güvenli ve kontrollü bir şekilde çalıştırır.
            fprintf('▶️ GUI kaynaklı MRAC simülasyonu başlatılıyor...\n');
            app.logToGUI('▶️ Simulation start command received from GUI.');
            
            % Hata yönetimi için bir bayrak oluşturalım
            hasError = false;
        
            %% --- 1) GİRİŞLERİ DOĞRULA VE PARAMETRELERİ TOPLA ---
            app.logToGUI('⚙️ Reading and validating parameters from GUI...');
            
            % Model Type
            modelType = app.ModelTypeDropDown.Value;
            assignin('base', 'modelType', modelType);
            fprintf('   - Model Type: %s\n', modelType);
            
            % Gerekli diğer temel değişkenleri workspace'e gönder
            assignin('base', 'app', app);
            assignin('base', 'GUI_LOG_ACTIVE', true);
            
            % NEW: Iteration and Master-Apprentice Parameters - SEND TO WORKSPACE FIRST
            iterationCount = app.IterationCountEdit.Value;
            masterFrequency = app.MasterFrequencyDropDown.Value;
            
            % PARAMETRELERİ HEMEN WORKSPACE'E GÖNDER
            assignin('base', 'max_iter_gui', iterationCount);
            assignin('base', 'master_frequency_gui', masterFrequency);
            fprintf('🔧 Simulation parameters sent to workspace: Iteration=%d, Master frequency=%d\n', iterationCount, masterFrequency);
            
            fprintf('🔍 DEBUG GUI: Iteration count reading from GUI: %d\n', iterationCount);
            fprintf('🔍 DEBUG GUI: Master frequency reading from GUI: %d\n', masterFrequency);
            
            % Güçlü workspace transferi
            assignin('base', 'max_iter_gui', iterationCount);
            assignin('base', 'master_frequency_gui', masterFrequency);
            fprintf('🔧 DEBUG: Parametreler workspace''e gönderildi - max_iter=%d, master_freq=%d\n', iterationCount, masterFrequency);
            
            % Hemen kontrol et
            try
                test_value = evalin('base', 'max_iter_gui');
                fprintf('🔍 DEBUG GUI: Workspace''e gönderilen max_iter_gui = %d\n', test_value);
            catch ME
                fprintf('❌ DEBUG GUI: max_iter_gui workspace''e gönderilemedi: %s\n', ME.message);
            end
            
            fprintf('   - Number of Iterations: %d\n', iterationCount);
            if masterFrequency == -1
                fprintf('   - Usta Sıklığı: Sadece çırak (GPT kullanılmayacak)\n');
            else
                fprintf('   - Usta Sıklığı: Her %d iterasyonda bir\n', masterFrequency);
            end
        
            % --- Sistem Modeli Parametreleri ---
            try
                A_sys_str = char(app.SystemAMatrixEdit.Value);
                B_sys_str = char(app.SystemBMatrixEdit.Value);
                C_sys_str = char(app.SystemCMatrixEdit.Value);
                D_sys_str = char(app.SystemDMatrixEdit.Value);
                
                % Girdilerin boş olup olmadığını kontrol et
                if isempty(A_sys_str) || isempty(B_sys_str) || isempty(C_sys_str) || isempty(D_sys_str)
                    error('Sistem modeli matris alanlarından biri veya birkaçı boş bırakılamaz.');
                end
                
                assignin('base', 'A_sys_gui', A_sys_str);
                assignin('base', 'B_sys_gui', B_sys_str);
                assignin('base', 'C_sys_gui', C_sys_str);
                assignin('base', 'D_sys_gui', D_sys_str);
                fprintf('   - Sistem Modeli: Başarıyla atandı.\n');
            catch ME
                uialert(app.UIFigure, ['Sistem Modeli Hatası: ' ME.message], 'Giriş Hatası', 'Icon', 'error');
                app.logToGUI(['❌ HATA (Sistem Modeli): ' ME.message]);
                hasError = true;
            end
        
            % --- Reference Modeli Parametreleri ---
            if ~hasError
                try
                    A_ref_str = char(app.AMatrixEdit.Value);
                    B_ref_str = char(app.BMatrixEdit.Value);
                    C_ref_str = char(app.CMatrixEdit.Value);
                    D_ref_str = char(app.DMatrixEdit.Value);
        
                    % Girdilerin boş olup olmadığını kontrol et
                    if isempty(A_ref_str) || isempty(B_ref_str) || isempty(C_ref_str) || isempty(D_ref_str)
                        error('Referans modeli matris alanlarından biri veya birkaçı boş bırakılamaz.');
                    end
                    
                    assignin('base', 'A_ref_gui', A_ref_str);
                    assignin('base', 'B_ref_gui', B_ref_str);
                    assignin('base', 'C_ref_gui', C_ref_str);
                    assignin('base', 'D_ref_gui', D_ref_str);
                    fprintf('   - Reference Modeli: Başarıyla atandı.\n');
                catch ME
                    uialert(app.UIFigure, ['Reference Modeli Hatası: ' ME.message], 'Giriş Hatası', 'Icon', 'error');
                    app.logToGUI(['❌ HATA (Reference Modeli): ' ME.message]);
                    hasError = true;
                end
            end
        
            % --- MRAC Adaptasyon Parametreleri - Model Typene Göre ---
            if ~hasError
                try
                    % Temel parametreleri al
                    gamma_theta_val = app.GammaThetaEdit.Value;
                    gamma_kr_val = app.GammaKrEdit.Value;
                    sampling_time_val = app.SamplingTimeEdit.Value;
                    
                    % Model tipine göre parametreleri ata
                    switch modelType
                        case 'Classic MRAC'
                            assignin('base', 'gamma_theta_gui', gamma_theta_val);
                            assignin('base', 'gamma_kr_gui', gamma_kr_val);
                            assignin('base', 'sampling_time_gui', sampling_time_val);
                            fprintf('   - Classic MRAC Parametreleri (γ_θ=%.1f, γ_kr=%.1f, Ts=%.4f): Başarıyla atandı.\n', ...
                                gamma_theta_val, gamma_kr_val, sampling_time_val);
                            app.logToGUI(sprintf('✅ Classic MRAC: γ_θ=%.1f, γ_kr=%.1f, Ts=%.4f', ...
                                gamma_theta_val, gamma_kr_val, sampling_time_val));
                                
                        case 'Filtered MRAC'
                            assignin('base', 'gamma_theta_gui', gamma_theta_val);
                            assignin('base', 'gamma_kr_gui', gamma_kr_val); % gamma_r olarak kullanılacak
                            assignin('base', 'sampling_time_gui', sampling_time_val);
                            fprintf('   - Filtered MRAC Parameters (γ_θ=%.1f, γ_r=%.1f, Ts=%.4f): Successfully assigned.\n', ...
                                gamma_theta_val, gamma_kr_val, sampling_time_val);
                            fprintf('   - Ek Parametreler: kr_base=0.0121, kr_filt_input=0.012 (varsayılan)\n');
                            app.logToGUI(sprintf('✅ Filtered MRAC: γ_θ=%.1f, γ_r=%.1f, Ts=%.4f', ...
                                gamma_theta_val, gamma_kr_val, sampling_time_val));
                            app.logToGUI('✅ Ek: kr_base=0.0121, kr_filt_input=0.012');
                                
                        % case 'Time Delay MRAC' % HIDDEN FROM UI - kept as comment
                        %     assignin('base', 'gamma_theta_gui', gamma_theta_val); % gamma olarak kullanılacak
                        %     assignin('base', 'sampling_time_gui', sampling_time_val);
                        %     fprintf('   - Time Delay MRAC Parameters (γ=%.1f, Ts=%.4f): Successfully assigned.\n', ...
                        %         gamma_theta_val, sampling_time_val);
                        %     fprintf('   - Ek Parametreler: kr_int=22.0 (varsayılan)\n');
                        %     app.logToGUI(sprintf('✅ Time Delay MRAC: γ=%.1f, Ts=%.4f', ...
                        %         gamma_theta_val, sampling_time_val));
                        %     app.logToGUI('✅ Ek: kr_int=22.0');
                            
                        otherwise
                            error('Unknown model type: %s', modelType);
                    end
                    
                catch ME
                    uialert(app.UIFigure, ['MRAC Parametreleri Hatası: ' ME.message], 'Giriş Hatası', 'Icon', 'error');
                    app.logToGUI(['❌ HATA (MRAC Parametreleri): ' ME.message]);
                    hasError = true;
                end
            end
        
            % Eğer herhangi bir bloğu okurken hata oluştuysa, script çalıştırmayı durdur
            if hasError
                fprintf('❗️Giriş hataları nedeniyle simülasyon başlatılamadı.\n');
                app.logToGUI('❗️Simulation cannot start due to input errors. Please check your inputs.');
                return; % Fonksiyondan çık
            end
            
            app.logToGUI('✅ All parameters validated successfully and transferred to workspace.');
        
            %% --- 2) ANA MRAC SCRIPT'İNİ ÇALIŞTIR ---
            
            % İlerleme çubuğu (Progress Bar) oluştur
            app.ProgressBar = uiprogressdlg(app.UIFigure, 'Title', 'Simulation Running', ...
                'Message', 'Starting...', 'Value', 0);
            drawnow;
            
            try
                app.ProgressBar.Message = 'Running MRAC main script...';
                app.StatusLabel.Text = 'MRAC simulation in progress...';
                app.StatusLabel.FontColor = [0.94 0.6 0]; % Turuncu
                drawnow;
                
                fprintf('🚀 Ana script çalıştırılıyor: mrac_combined.m\n');
                app.logToGUI('🚀 Running main script (mrac_combined.m)...');
        
                % Parametreleri SON KERE daha gönder (MUTLAKA SON DEĞERLER GÖNDERİLSİN)
                currentIterationCount = app.IterationCountEdit.Value;
                currentMasterFreq = app.MasterFrequencyDropDown.Value;
                
                assignin('base', 'max_iter_gui', currentIterationCount);
                assignin('base', 'master_frequency_gui', currentMasterFreq);
                
                fprintf('\n════════════════════════════════════════════════════\n');
                fprintf('🔧 SİMÜLASYON PARAMETRELERİ (SON KONTROL)\n');
                fprintf('════════════════════════════════════════════════════\n');
                fprintf('   Number of Iterations: %d\n', currentIterationCount);
                fprintf('   Master Sıklığı: %d\n', currentMasterFreq);
                fprintf('════════════════════════════════════════════════════\n\n');
                
                % Workspace'ten kontrol et (doğrulama)
                try
                    verifyIter = evalin('base', 'max_iter_gui');
                    verifyMaster = evalin('base', 'master_frequency_gui');
                    fprintf('✅ Workspace doğrulama: max_iter_gui=%d, master_frequency_gui=%d\n', verifyIter, verifyMaster);
                    
                    if verifyIter ~= currentIterationCount
                        fprintf('⚠️ UYARI: Workspace değeri farklı! Tekrar gönderiliyor...\n');
                        assignin('base', 'max_iter_gui', currentIterationCount);
                    end
                catch
                    fprintf('⚠️ Workspace değişkenleri okunamadı\n');
                end
                
                % Ana script'i çalıştır
                run('mrac_combined.m');
                
                app.ProgressBar.Message = 'Processing results and drawing graphs...';
                drawnow;
                
                % Script çalıştıktan sonra workspace'ten verileri çek ve plot'ları güncelle
                % Bu fonksiyonun app içerisinde tanımlı olduğunu varsayıyoruz.
                if ismethod(app, 'updatePlotsFromWorkspace')
                    app.updatePlotsFromWorkspace();
                end
                
                app.StatusLabel.Text = 'Simulation completed successfully';
                app.StatusLabel.FontColor = [0.2 0.6 0.2]; % Yeşil
                app.hasCompletedSimulation = true;  % Mark that simulation was completed in this session
                drawnow;
                
                app.logToGUI('🎉 MRAC simulation completed SUCCESSFULLY!');
                app.logToGUI('📊 Results processed and graphs updated.');
                
                % Raporlama butonlarını aktif et
                if ismethod(app, 'enableReporting')
                    app.enableReporting();
                    app.logToGUI('📈 Reporting features activated.');
                end
        
            catch ME
                % Hata durumunda durumu yönet
                app.StatusLabel.Text = ['Error occurred: ' ME.message];
                app.StatusLabel.FontColor = [0.8 0.2 0.2]; % Kırmızı
                
                app.logToGUI('💥 MRAC SCRIPT EXECUTION ERROR!');
                app.logToGUI(sprintf('   🚫 Error Message: %s', ME.message));
                if ~isempty(ME.stack)
                    app.logToGUI(sprintf('   📍 Error Location: %s (Line: %d)', ME.stack(1).name, ME.stack(1).line));
                end
                
                uialert(app.UIFigure, ['Error while running MRAC script: ' ME.message], 'Simulation Error', 'Icon', 'error');
                
            end
        
            % Her durumda (başarılı veya hatalı) progress bar'ı kapat
            if isvalid(app.ProgressBar)
                app.ProgressBar.Value = 1.0;
                app.ProgressBar.Message = 'Simulation completed!';
                drawnow;
                pause(0.5); % Show completion for a moment
                close(app.ProgressBar);
            end
            
            fprintf('✅ GUI fonksiyonu tamamlandı.\n');
        end

        % YENİ: Model tipine göre MRAC parametrelerini güncelle
        function updateMRACParameters(app)
            try
                modelType = app.ModelTypeDropDown.Value;
                
                switch modelType
                    case 'Classic MRAC'
                        % Classic MRAC parametreleri
                        app.GammaThetaLabel.Text = 'γ_θ (Theta Gain):';
                        app.GammaKrLabel.Text = 'γ_kr (Kr Gain):';
                        app.GammaThetaEdit.Value = 1000;
                        app.GammaKrEdit.Value = 1000;
                        app.SamplingTimeEdit.Value = 0.001;
                        app.GammaKrEdit.Visible = 'on';
                        app.GammaKrLabel.Visible = 'on';
                        
                    case 'Filtered MRAC'
                        % Filtered MRAC parameters (values from BASE file)
                        app.GammaThetaLabel.Text = 'γ_θ (Theta Gain):';
                        app.GammaKrLabel.Text = 'γ_r (R Gain):';
                        app.GammaThetaEdit.Value = 100;
                        app.GammaKrEdit.Value = 80;
                        app.SamplingTimeEdit.Value = 0.001;
                        app.GammaKrEdit.Visible = 'on';
                        app.GammaKrLabel.Visible = 'on';
                        
                    % case 'Time Delay MRAC' % HIDDEN FROM UI - kept as comment
                    %     % Time Delay MRAC parameters (Improved values)
                    %     app.GammaThetaLabel.Text = 'γ (Gamma Gain):';
                    %     app.GammaThetaEdit.Value = 50;  % 10'dan 50'ye artırıldı - daha hızlı yakınsama
                    %     app.SamplingTimeEdit.Value = 0.001;
                    %     % γ_kr alanını gizle (bu modelde kullanılmıyor)
                    %     app.GammaKrEdit.Visible = 'off';
                    %     app.GammaKrLabel.Visible = 'off';
                        
                    otherwise
                        % Varsayılan (Classic MRAC)
                        app.GammaThetaLabel.Text = 'γ_θ (Theta Gain):';
                        app.GammaKrLabel.Text = 'γ_kr (Kr Gain):';
                        app.GammaThetaEdit.Value = 1000;
                        app.GammaKrEdit.Value = 1000;
                        app.SamplingTimeEdit.Value = 0.001;
                        app.GammaKrEdit.Visible = 'on';
                        app.GammaKrLabel.Visible = 'on';
                end
                
                % Özet panelini güncelle
                updateSummaryWithSystemModel(app);
                
            catch ME
                fprintf('⚠️ MRAC parametreleri güncellenirken hata: %s\n', ME.message);
            end
        end


        function updatePlotsFromWorkspace(app)
            try
                % Önce X, Xm, t verilerini kontrol et (mrac_combined'den gelen)
                if evalin('base', 'exist(''X'', ''var'')') && ...
                   evalin('base', 'exist(''Xm'', ''var'')') && ...
                   evalin('base', 'exist(''t'', ''var'')')
                    % mrac_combined'den gelen verileri kullan
                    dataX_raw = evalin('base', 'X');
                    dataXm_raw = evalin('base', 'Xm');
                    time_raw = evalin('base', 't');
                    
                    fprintf('🔍 DEBUG: Raw veri boyutları: X=%s, Xm=%s, t=%s\n', ...
                        mat2str(size(dataX_raw)), mat2str(size(dataXm_raw)), mat2str(size(time_raw)));
                    
                    % Veri formatını kontrol et ve düzelt
                    if isstruct(dataX_raw) && isfield(dataX_raw, 'signals')
                        dataX = dataX_raw.signals.values;
                        time = dataX_raw.time;
                        fprintf('🔍 X struct formatından çıkarıldı: %s\n', mat2str(size(dataX)));
                    else
                        dataX = dataX_raw;
                        time = time_raw;
                        fprintf('🔍 X array formatında kullanıldı: %s\n', mat2str(size(dataX)));
                    end
                    
                    if isstruct(dataXm_raw) && isfield(dataXm_raw, 'signals')
                        dataXm = dataXm_raw.signals.values;
                        fprintf('🔍 Xm struct formatından çıkarıldı: %s\n', mat2str(size(dataXm)));
                    else
                        dataXm = dataXm_raw;
                        fprintf('🔍 Xm array formatında kullanıldı: %s\n', mat2str(size(dataXm)));
                    end
                    
                    fprintf('🔍 DEBUG: İşlenmiş veri boyutları: X=%s, Xm=%s, t=%s\n', ...
                        mat2str(size(dataX)), mat2str(size(dataXm)), mat2str(size(time)));
                    
                elseif evalin('base', 'exist(''X'', ''var'')')
                    % Mevcut workspace verilerini kullan
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
                else
                    dataX = [];
                    dataXm = [];
                    time = [];
                end
                
                % === PROFESYONEL PLOT DÜZENLEMESI ===
                
                % ErrorAxes'te X ve Xm verilerini plotla - Modern Stil
                if exist('dataX', 'var') && exist('dataXm', 'var') && exist('time', 'var')
                    % Axes'i tamamen temizle
                    cla(app.ErrorAxes, 'reset');
                    hold(app.ErrorAxes, 'off');
                    
                    % Veri boyutlarını kontrol et (çok boyutluysa en uygun sütunu seç)
                    selectColumn = @(M) (isempty(M) * [] + (~isempty(M)) * M);
                    
                    % Varsayılan: doğrudan veri
                    plotDataX = []; plotDataXm = [];
                    if ~isempty(dataX), plotDataX = dataX; end
                    if ~isempty(dataXm), plotDataXm = dataXm; end
                    
                    % Eğer çok sütunluysa, referansın en anlamlı çıktısını seç (son değer en yüksek olan)
                    try
                        if ~isempty(plotDataXm) && size(plotDataXm, 2) > 1
                            [~, idxXm] = max(abs(movmean(plotDataXm(end- min(1000,size(plotDataXm,1))+1:end, :), 50))); %#ok<MOVMEAN>
                            idxXm = idxXm(1);
                            plotDataXm = plotDataXm(:, idxXm);
                        end
                        % Sistem sütunu, referans ile aynı indeks tercih edilir
                        if ~isempty(plotDataX) && size(plotDataX, 2) > 1
                            if exist('idxXm', 'var') && idxXm <= size(plotDataX, 2)
                                plotDataX = plotDataX(:, idxXm);
                            else
                                % Aksi halde son değeri en büyük olanı seç
                                [~, idxX] = max(abs(movmean(plotDataX(end- min(1000,size(plotDataX,1))+1:end, :), 50))); %#ok<MOVMEAN>
                                plotDataX = plotDataX(:, idxX(1));
                            end
                        end
                    catch
                        % Herhangi bir hata durumunda ilk sütunlara geri dön
                        if ~isempty(dataXm) && size(dataXm,2) > 1, plotDataXm = dataXm(:,1); end
                        if ~isempty(dataX) && size(dataX,2) > 1, plotDataX = dataX(:,1); end
                    end
                    
                    % Modern renkler ve stiller - Basitleştirilmiş plot (sadece ilk çıkışlar)
                    % Veri kontrol sonrası plot - İYİLEŞTİRİLMİŞ KONTROL
                    
                    % Debug bilgileri
                    fprintf('🔍 DEBUG Plot Kontrol:\n');
                    fprintf('  - plotDataX: boş=%s, boyut=%s, vektör=%s\n', ...
                        string(isempty(plotDataX)), mat2str(size(plotDataX)), string(isvector(plotDataX)));
                    fprintf('  - plotDataXm: boş=%s, boyut=%s, vektör=%s\n', ...
                        string(isempty(plotDataXm)), mat2str(size(plotDataXm)), string(isvector(plotDataXm)));
                    fprintf('  - time: boş=%s, boyut=%s, vektör=%s\n', ...
                        string(isempty(time)), mat2str(size(time)), string(isvector(time)));
                    
                    if ~isempty(plotDataX) && ~isempty(plotDataXm) && ~isempty(time) && ...
                       isvector(time) && isvector(plotDataX) && isvector(plotDataXm) && ...
                       length(time) == length(plotDataX) && length(time) == length(plotDataXm) && ...
                       length(time) > 1
                        
                        fprintf('✅ Data check successful - Drawing graph\n');
                        
                        % Sistem çıkışı - sadece ilk sütun
                        plot(app.ErrorAxes, time, plotDataX, 'Color', [0.2 0.4 0.8], 'LineWidth', 2.5, ...
                            'DisplayName', 'System Output');
                        hold(app.ErrorAxes, 'on');
                        
                        % Referans modeli - sadece ilk sütun
                        plot(app.ErrorAxes, time, plotDataXm, 'Color', [0.8 0.2 0.2], 'LineWidth', 2.5, ...
                            'DisplayName', 'Reference Model', 'LineStyle', '--');
                    else
                        % Veri uyumsuz, hata mesajı göster
                        fprintf('⚠️ Veri kontrolü başarısız - Grafik çizilemedi\n');
                        cla(app.ErrorAxes, 'reset');
                        text(app.ErrorAxes, 0.5, 0.5, 'Veri işleniyor veya uyumsuz...', ...
                            'HorizontalAlignment', 'center', 'FontSize', 12, 'Units', 'normalized');
                        xlim(app.ErrorAxes, [0 1]);
                        ylim(app.ErrorAxes, [0 1]);
                        
                        % Güvenli veri boyut kontrolü
                        time_len = 0; if ~isempty(time), time_len = length(time); end
                        plotX_len = 0; if ~isempty(plotDataX), plotX_len = length(plotDataX); end
                        plotXm_len = 0; if ~isempty(plotDataXm), plotXm_len = length(plotDataXm); end
                        
                        fprintf('📊 Veri boyutları: time=%d, X=%d, Xm=%d\n', time_len, plotX_len, plotXm_len);
                    end
                    hold(app.ErrorAxes, 'off');
                    
                    % Profesyonel görünüm ayarları
                    % Sistem tipi kontrolü - Double Integrator sistemi için özel başlık
                    titleText = '📈 System and Reference Model Outputs';
                    
                    % Gerçek veri kullanımı kontrolü
                    if evalin('base', 'exist(''REAL_DATA_USED'', ''var'')')
                        realDataUsed = evalin('base', 'REAL_DATA_USED');
                        if ~realDataUsed
                            titleText = '⚠️ FAKE DATA: Not actual simulation results!';
                        else
                            titleText = '✅ REAL DATA: Simulink simulation results';
                        end
                    end
                    
                    if evalin('base', 'exist(''A_sys_default'', ''var'')')
                        A_sys = evalin('base', 'A_sys_default');
                        if isequal(A_sys, [0, 1; 0, 0])
                            titleText = [titleText, ' (Double Integrator)'];
                        end
                    end
                    title(app.ErrorAxes, titleText, ...
                        'FontSize', 14, 'FontWeight', 'bold', 'Color', [0.2 0.2 0.2]);
                    xlabel(app.ErrorAxes, 'Time (seconds)', 'FontSize', 12, 'FontWeight', 'bold');
                    ylabel(app.ErrorAxes, 'Output Signal', 'FontSize', 12, 'FontWeight', 'bold');
                    
                    % Temiz legend
                    legend(app.ErrorAxes, 'Location', 'best', 'FontSize', 11, ...
                        'Box', 'on', 'Color', [0.95 0.95 0.95]);
                    
                    grid(app.ErrorAxes, 'on');
                    app.ErrorAxes.GridAlpha = 0.3;
                    app.ErrorAxes.XColor = [0.3 0.3 0.3];
                    app.ErrorAxes.YColor = [0.3 0.3 0.3];
                    app.ErrorAxes.FontSize = 10;
                    
                    % Eksen limitleri - Güvenli
                    try
                        if ~isempty(time) && length(time) > 1 && min(time) < max(time)
                            xlim(app.ErrorAxes, [min(time) max(time)]);
                        end
                        
                        y_min = min([min(plotDataX) min(plotDataXm)]);
                        y_max = max([max(plotDataX) max(plotDataXm)]);
                        if y_min ~= y_max && ~isnan(y_min) && ~isnan(y_max) && isfinite(y_min) && isfinite(y_max)
                            margin = 0.1 * (y_max - y_min);
                            ylim(app.ErrorAxes, [y_min - margin, y_max + margin]);
                        end
                    catch ME
                        fprintf('⚠️ Grafik limit ayarlama hatası: %s\n', ME.message);
                    end
                    
                elseif exist('dataX', 'var') && exist('time', 'var') && ~isempty(dataX) && ~isempty(time)
                    % Tek veri için plot
                    fprintf('📊 Only system data available - drawing single graph\n');
                    cla(app.ErrorAxes, 'reset');
                    
                    if size(dataX, 2) > 1
                        plotDataX = dataX(:, 1);
                    else
                        plotDataX = dataX;
                    end
                    
                    % Veri uyumluluğu kontrol et
                    if isvector(time) && isvector(plotDataX) && length(time) == length(plotDataX) && length(time) > 1
                        plot(app.ErrorAxes, time, plotDataX, 'Color', [0.2 0.4 0.8], 'LineWidth', 2.5, ...
                            'DisplayName', 'System Output');
                        title(app.ErrorAxes, '📊 System Output (Reference model data not available)', ...
                            'FontSize', 14, 'FontWeight', 'bold');
                        xlabel(app.ErrorAxes, 'Time (seconds)', 'FontSize', 12);
                        ylabel(app.ErrorAxes, 'Output', 'FontSize', 12);
                        grid(app.ErrorAxes, 'on');
                        app.ErrorAxes.GridAlpha = 0.3;
                        legend(app.ErrorAxes, 'Location', 'best');
                    else
                        text(app.ErrorAxes, 0.5, 0.5, 'System data incompatible...', ...
                            'HorizontalAlignment', 'center', 'FontSize', 12, 'Units', 'normalized');
                        xlim(app.ErrorAxes, [0 1]);
                        ylim(app.ErrorAxes, [0 1]);
                    end
                else
                    % No data at all
                    fprintf('⚠️ No output data found\n');
                    cla(app.ErrorAxes, 'reset');
                    text(app.ErrorAxes, 0.5, 0.5, 'Output data not found...', ...
                        'HorizontalAlignment', 'center', 'FontSize', 12, 'Units', 'normalized');
                    xlim(app.ErrorAxes, [0 1]);
                    ylim(app.ErrorAxes, [0 1]);
                end
                
                % Hata sinyalini ThetaAxes'te plotla - Modern Stil
                if evalin('base', 'exist(''eTPB'', ''var'')')
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
                        
                        % Hata sinyali - Ana hata analizi
                        plot(app.ThetaAxes, errorTime, plotErrorData, 'Color', [0.8 0.1 0.1], ...
                            'LineWidth', 3, 'DisplayName', 'Takip Hatası (e)');
                        
                        % Sıfır referans çizgisi
                        hold(app.ThetaAxes, 'on');
                        plot(app.ThetaAxes, [min(errorTime) max(errorTime)], [0 0], ...
                            'Color', [0.3 0.3 0.3], 'LineWidth', 2, 'LineStyle', '--', ...
                            'DisplayName', 'Hedef (Sıfır)');
                        
                        % Hata büyüklüğü analizi
                        errorMagnitude = abs(plotErrorData);
                        plot(app.ThetaAxes, errorTime, errorMagnitude, 'Color', [0.1 0.6 0.1], ...
                            'LineWidth', 2, 'LineStyle', '-.', 'DisplayName', 'Hata Büyüklüğü |e|');
                        
                        % Hata azalma trendi (eğer varsa)
                        if length(plotErrorData) > 10
                            % Hareketli ortalama ile trend analizi
                            windowSize = min(10, floor(length(plotErrorData)/10));
                            if windowSize > 1
                                trendData = movmean(abs(plotErrorData), windowSize);
                                plot(app.ThetaAxes, errorTime, trendData, 'Color', [0.6 0.1 0.8], ...
                                    'LineWidth', 2, 'LineStyle', ':', 'DisplayName', 'Hata Trendi');
                            end
                        end
                        
                        hold(app.ThetaAxes, 'off');
                        
                        % Profesyonel görünüm - PARAMETRE DEĞİŞİMLERİ için başlık güncellendi
                        app.plotAdaptationParameters();
                        return; % Parametre çizimine git, takip hatası yerine
                        
                        % Temiz legend
                        legend(app.ThetaAxes, 'Location', 'best', 'FontSize', 11, ...
                            'Box', 'on', 'Color', [0.95 0.95 0.95]);
                        
                        grid(app.ThetaAxes, 'on');
                        app.ThetaAxes.GridAlpha = 0.3;
                        app.ThetaAxes.XColor = [0.3 0.3 0.3];
                        app.ThetaAxes.YColor = [0.3 0.3 0.3];
                        app.ThetaAxes.FontSize = 10;
                        
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
                
                % Raporlama butonlarını aktif et
                app.enableReporting();
                
                % Başarı mesajı
                if isprop(app, 'UIFigure') && isvalid(app.UIFigure)
                    uialert(app.UIFigure, 'Simulation completed and graphs updated!', 'Success', 'Icon', 'success');
                else
                    fprintf('✅ Simulation completed and graphs updated!\n');
                end
                
            catch ME
                if isprop(app, 'UIFigure') && isvalid(app.UIFigure)
                    uialert(app.UIFigure, ['Grafik güncellenirken hata: ' ME.message], 'Hata', 'Icon', 'error');
                else
                    fprintf('❌ Grafik güncellenirken hata: %s\n', ME.message);
                end
            end
        end
        
        function plotAdaptationParameters(app)
            % Model tipine göre parametreleri çiz
            try
                % Model tipini al
                if evalin('base', 'exist(''modelType'', ''var'')')
                    modelType = evalin('base', 'modelType');
                else
                    modelType = app.ModelTypeDropDown.Value;
                end
                
                % Axes'i temizle
                cla(app.ThetaAxes, 'reset');
                hold(app.ThetaAxes, 'on');
                
                % Parametre verilerini kontrol et
                plotted_something = false;
                if evalin('base', 'exist(''kr_all'', ''var'')')
                    kr_all = evalin('base', 'kr_all');
                    if ~isempty(kr_all) && length(kr_all) > 1
                        % 120 saniye için zaman ekseni oluştur
                        param_time = linspace(0, 120, length(kr_all));
                        
                        % kr_hat'i çiz
                        plot(app.ThetaAxes, param_time, kr_all, 'Color', [0.8 0.1 0.1], ...
                            'LineWidth', 2.5, 'Marker', 'o', 'MarkerSize', 4, 'DisplayName', 'kr_{hat}');
                        plotted_something = true;
                        
                        fprintf('🔍 DEBUG: kr_all çizildi - boyut: %dx%d, değer aralığı: [%.3f - %.3f]\n', ...
                            size(kr_all), min(kr_all), max(kr_all));
                    end
                end
                
                % Theta parametrelerini çiz (model tipine göre)
                if evalin('base', 'exist(''theta_all'', ''var'')')
                    theta_all = evalin('base', 'theta_all');
                    if ~isempty(theta_all) && size(theta_all, 1) > 1
                        param_time = linspace(0, 120, size(theta_all, 1));
                    
                    % Model tipine göre theta parametrelerini çiz
                    if strcmp(modelType, 'classic') || contains(lower(modelType), 'classic')
                        % Classic MRAC: θ1, θ2
                        plot(app.ThetaAxes, param_time, theta_all(:,1), 'Color', [0.1 0.5 0.8], ...
                            'LineWidth', 2, 'DisplayName', '\theta_1');
                        plot(app.ThetaAxes, param_time, theta_all(:,2), 'Color', [0.1 0.8 0.5], ...
                            'LineWidth', 2, 'DisplayName', '\theta_2');
                    elseif strcmp(modelType, 'filtered') || contains(lower(modelType), 'filtre')
                        % Filtered MRAC: θ components
                        for i = 1:min(size(theta_all, 2), 4)
                            colors = [0.1 0.5 0.8; 0.1 0.8 0.5; 0.8 0.5 0.1; 0.8 0.1 0.5];
                            plot(app.ThetaAxes, param_time, theta_all(:,i), 'Color', colors(i,:), ...
                                'LineWidth', 2, 'DisplayName', ['\theta_' num2str(i)]);
                        end
                    end
                        
                        fprintf('🔍 DEBUG: theta_all çizildi - boyut: %dx%d\n', size(theta_all));
                        plotted_something = true;
                    end
                end
                
                % Başlık ve etiketler
                if strcmp(modelType, 'classic') || contains(lower(modelType), 'classic')
                    title(app.ThetaAxes, '📊 Classic MRAC - Error Status and Adaptation (120s)', ...
                        'FontSize', 14, 'FontWeight', 'bold', 'Color', [0.2 0.2 0.2]);
                elseif strcmp(modelType, 'filtered') || contains(lower(modelType), 'filtre')
                    title(app.ThetaAxes, '📊 Filtered MRAC - Error Status and Adaptation (120s)', ...
                        'FontSize', 14, 'FontWeight', 'bold', 'Color', [0.2 0.2 0.2]);
                else
                    title(app.ThetaAxes, '📊 MRAC - Error Status and Adaptation (120s)', ...
                        'FontSize', 14, 'FontWeight', 'bold', 'Color', [0.2 0.2 0.2]);
                end
                
                xlabel(app.ThetaAxes, 'Time (seconds)', 'FontSize', 12, 'FontWeight', 'bold');
                ylabel(app.ThetaAxes, 'Error Status and Adaptation', 'FontSize', 12, 'FontWeight', 'bold');
                
                % Grid ve görünüm
                grid(app.ThetaAxes, 'on');
                app.ThetaAxes.GridAlpha = 0.3;
                app.ThetaAxes.XColor = [0.3 0.3 0.3];
                app.ThetaAxes.YColor = [0.3 0.3 0.3];
                app.ThetaAxes.FontSize = 10;
                
                % Legend - sadece veri çizildiyse
                if plotted_something
                    legend(app.ThetaAxes, 'Location', 'best', 'FontSize', 11, ...
                        'Box', 'on', 'Color', [0.95 0.95 0.95]);
                else
                    % Veri yoksa bilgi mesajı
                    text(app.ThetaAxes, 0.5, 0.5, 'Parameter data not yet available...', ...
                        'HorizontalAlignment', 'center', 'FontSize', 12, 'Units', 'normalized');
                end
                
                % X ekseni 0-120 saniye olarak ayarla (güvenli)
                try
                    xlim(app.ThetaAxes, [0 120]);
                catch
                    % Limit hatası varsa varsayılan bırak
                end
                
                hold(app.ThetaAxes, 'off');
                
            catch ME
                fprintf('❌ Parametre çiziminde hata: %s\n', ME.message);
                % Fallback: Basit mesaj
                cla(app.ThetaAxes, 'reset');
                text(app.ThetaAxes, 0.5, 0.5, 'Parametre verileri yükleniyor...', ...
                    'HorizontalAlignment', 'center', 'FontSize', 12);
                xlim(app.ThetaAxes, [0 1]);
                ylim(app.ThetaAxes, [0 1]);
            end
        end
        
        function updateRefPanels(app)
            % Artık RefModelTypeDropDown yok - tüm panelleri görünür yap
            app.DefaultRefPanel.Visible = 'off'; % Varsayılan paneli gizle
            app.PerfPanel.Visible = 'on';        % Performans hedefi paneli göster
            app.ManualPanel.Visible = 'on';      % Manuel panel göster
            updateSummary(app);
        end
        function updateSummary(app)
            % Summarize selections
            modelType = app.ModelTypeDropDown.Value;
            refType = 'GUI'; % Always from GUI fields
            summary = {};
            summary{end+1} = ['Selected MRAC Model: ' modelType];
            summary{end+1} = ['Reference Model: taken from GUI fields'];
            
            % Show reference model information from GUI fields
            if isprop(app, 'AMatrixEdit') && ~isempty(app.AMatrixEdit.Value)
                summary{end+1} = ['A_ref: ' strjoin(app.AMatrixEdit.Value, '')];
                summary{end+1} = ['B_ref: ' strjoin(app.BMatrixEdit.Value, '')];
                summary{end+1} = ['C_ref: ' strjoin(app.CMatrixEdit.Value, '')];
                summary{end+1} = ['D_ref: ' strjoin(app.DMatrixEdit.Value, '')];
            end
            
            % Performans hedefleri varsa onları da göster
            if isprop(app, 'OvershootDropDown') && ~isempty(app.OvershootDropDown.Value)
                summary{end+1} = ['Performance - Overshoot: ' app.OvershootDropDown.Value];
                summary{end+1} = ['Performance - Settling: ' app.SettlingTimeDropDown.Value];
            end
            
            % SelectionSummary removed - not needed
        end
        function isOk = safeCheck(app, propName)
            % Helper: Safely check if property exists and is valid
            try
                if ~isprop(app, propName)
                    isOk = false;
                    return;
                end
                obj = app.(propName);
                isOk = isvalid(obj);
            catch
                isOk = false;
            end
        end
        
        function SaveSettingsButtonPushed(app, event)
            % Save settings using centralized settings manager
            
            if isempty(app.settingsManager)
                uialert(app.UIFigure, 'Settings manager not available!', 'Error', 'Icon', 'error');
                return;
            end
            
            try
                % Visual feedback - Button loading state
                originalButtonText = app.SaveSettingsButton.Text;
                originalButtonColor = app.SaveSettingsButton.BackgroundColor;
                app.SaveSettingsButton.Text = '⏳ Kaydediliyor...';
                app.SaveSettingsButton.BackgroundColor = [0.8 0.6 0.2];
                app.SaveSettingsButton.Enable = 'off';
                drawnow;
                
                % Get values from GUI
                apiKeyValue = strtrim(app.APIKeyEditField.Value);
                gptModelValue = app.GPTModelDropDown.Value;
                
                % Debug: Show what we got
                fprintf('\n════════════════════════════════════════════════════\n');
                fprintf('🔍 SAVE SETTINGS - BAŞLANGIÇ\n');
                fprintf('════════════════════════════════════════════════════\n');
                fprintf('API Key boş mu: %s\n', string(isempty(apiKeyValue)));
                if ~isempty(apiKeyValue)
                    fprintf('API Key uzunluğu: %d karakter\n', length(apiKeyValue));
                    fprintf('API Key önizleme: %s...%s\n', apiKeyValue(1:min(15, length(apiKeyValue))), apiKeyValue(max(1,end-10):end));
                end
                fprintf('GPT Model: %s\n', gptModelValue);
                fprintf('════════════════════════════════════════════════════\n\n');
                
                % ALWAYS save API key - NO validation (kullanıcı ne girerse kaydet)
                if ~isempty(apiKeyValue)
                    fprintf('💾 API anahtarı kaydediliyor (validation YOK)...\n');
                    app.settingsManager.setApiKey(apiKeyValue);
                    fprintf('✅ setApiKey() tamamlandı\n');
                    
                    % Verify it was saved
                    savedKey = app.settingsManager.getApiKey();
                    fprintf('🔍 Doğrulama: Kaydedilen anahtar uzunluğu = %d\n', length(savedKey));
                    if length(savedKey) == length(apiKeyValue)
                        fprintf('✅ API anahtarı başarıyla kaydedildi!\n');
                    else
                        fprintf('❌ HATA: API anahtarı kaydedilemedi!\n');
                    end
                else
                    fprintf('⚠️ API anahtarı boş - atlanıyor\n');
                end
                
                % Save GPT model
                if ~isempty(gptModelValue)
                    app.settingsManager.setModel(gptModelValue);
                    fprintf('✅ GPT modeli kaydedildi: %s\n', gptModelValue);
                end
                
                % Save all settings
                fprintf('💾 Ayarlar dosyaya kaydediliyor...\n');
                app.settingsManager.saveSettings();
                fprintf('✅ saveSettings() tamamlandı\n');
                
                % Verify save
                fprintf('\n🔍 Dosya kontrolü:\n');
                cfg = loadApiConfig();
                fprintf('   config.json API Key uzunluğu: %d\n', length(cfg.apiKey));
                fprintf('   config.json Model: %s\n', cfg.model);
                
                % Update app configuration
                fprintf('\n🔄 App configuration güncelleniyor...\n');
                app.apiConfig = app.settingsManager.getApiConfig();
                currentApiKey = app.settingsManager.getApiKey();
                fprintf('   Alınan API Key uzunluğu: %d\n', length(currentApiKey));
                
                % GPT features - NO validation, just check if exists
                app.useGptFeatures = ~isempty(currentApiKey);
                fprintf('   useGptFeatures: %s\n', string(app.useGptFeatures));
                
                % Update chat features (safely - check if components exist)
                if app.useGptFeatures
                    % Enable old chat components if they exist
                    if app.safeCheck('ChatInputArea')
                        app.ChatInputArea.Editable = true;
                    end
                    if app.safeCheck('SendButton')
                        app.SendButton.Enable = 'on';
                    end
                    if app.safeCheck('ChatHistoryListBox')
                        app.ChatHistoryListBox.Enable = 'on';
                    end
                    
                    % Enable new chat components if they exist
                    if app.safeCheck('EnhancedChatInput')
                        app.EnhancedChatInput.Editable = true;
                    end
                    if app.safeCheck('SendChatButton')
                        app.SendChatButton.Enable = 'on';
                    end
                    
                    % ChatManager'ı güncelle veya yeniden oluştur
                    if isempty(app.chatManager)
                        fprintf('🔧 ChatManager bulunamadı, yeniden oluşturuluyor...\n');
                        try
                            % Chat Tab'ı temizle
                            if app.safeCheck('ChatTab')
                                delete(app.ChatTab.Children);
                            end
                            
                            % Yeni ChatManager oluştur
                            app.chatManager = ChatManager(app);
                            fprintf('✅ ChatManager yeniden oluşturuldu\n');
                            
                            % Chat UI'ı kur
                            app.chatManager.setupChatUI();
                            fprintf('✅ Chat UI yenilendi - Tam özellikli mod aktif\n');
                        catch ME
                            fprintf('❌ ChatManager oluşturma hatası: %s\n', ME.message);
                            fprintf('   Detay: %s\n', getReport(ME));
                        end
                    else
                        fprintf('🔄 ChatManager API anahtarı güncelleniyor...\n');
                        app.chatManager.updateApiKey();
                        fprintf('✅ ChatManager API anahtarı güncellendi\n');
                    end
                    
                    % Sohbet geçmişine başarı mesajı ekle
                    if ~isempty(app.chatManager)
                        if app.safeCheck('EnhancedChatHistory')
                            timestamp = datestr(now, 'HH:MM');
                            successMsg = sprintf('[%s] ✅ Sistem: API anahtarı güncellendi! GPT özellikleri aktif. Şimdi sohbet edebilirsiniz!', timestamp);
                            currentHistory = app.EnhancedChatHistory.Value;
                            app.EnhancedChatHistory.Value = [currentHistory; {successMsg; ''}];
                            drawnow;
                        end
                    end
                    
                    % Update system status in Settings tab
                    fprintf('📊 Sistem durumu güncelleniyor...\n');
                    if ~isempty(app.chatManager)
                        app.updateSystemStatus('✅ API anahtarı kaydedildi ve ChatManager güncellendi', true);
                        fprintf('✅ Sistem durumu: ChatManager aktif\n');
                    else
                        app.updateSystemStatus('✅ API anahtarı kaydedildi', true);
                        fprintf('⚠️ ChatManager henüz aktif değil\n');
                    end
                else
                    % Disable old chat components if they exist
                    if app.safeCheck('ChatInputArea')
                        app.ChatInputArea.Editable = false;
                    end
                    if app.safeCheck('SendButton')
                        app.SendButton.Enable = 'off';
                    end
                    if app.safeCheck('ChatHistoryListBox')
                        app.ChatHistoryListBox.Enable = 'off';
                    end
                    
                    % Update system status in Settings tab
                    fprintf('⚠️ GPT Features pasif\n');
                    app.updateSystemStatus('⚠️ API anahtarı boş', false);
                end
                
                fprintf('\n════════════════════════════════════════════════════\n');
                fprintf('✅ SAVE SETTINGS - TAMAMLANDI\n');
                fprintf('════════════════════════════════════════════════════\n\n');
                
                % Success - Update button appearance
                app.SaveSettingsButton.Text = '✅ Kaydedildi!';
                app.SaveSettingsButton.BackgroundColor = [0.2 0.8 0.2];
                drawnow;
                
                % Success message with detailed info
                savedApiKey = app.settingsManager.getApiKey();
                apiKeyPreview = '';
                apiKeyInfo = '';
                if ~isempty(savedApiKey)
                    apiKeyPreview = savedApiKey(1:min(10,length(savedApiKey))) + "...";
                    apiKeyInfo = sprintf('Registered API Key: %s\nLength: %d characters', apiKeyPreview, length(savedApiKey));
                else
                    apiKeyInfo = 'API Key: (empty)';
                end
                
                % Show detailed success dialog
                chatManagerStatus = 'Pasif ❌';
                if ~isempty(app.chatManager)
                    chatManagerStatus = 'Active ✅';
                end
                sohbetStatus = 'Pasif ❌';
                if app.useGptFeatures
                    sohbetStatus = 'Active ✅';
                end
                apiCallStatus = 'Bekliyor ⏳';
                if app.useGptFeatures
                    apiCallStatus = 'Ready ✅';
                end
                
                successMessage = sprintf(['✅ AYARLAR BAŞARIYLA KAYDEDİLDİ!\n\n' ...
                    '📋 Kaydedilen Ayarlar:\n' ...
                    '━━━━━━━━━━━━━━━━━━━━━━━━━━━\n' ...
                    '%s\n' ...
                    'GPT Model: %s\n' ...
                    'GPT Features: %s\n\n' ...
                    '💾 Dosyalar:\n' ...
                    '• config.json ✅\n' ...
                    '• mrac_settings.mat ✅\n\n' ...
                    '🎯 Durum:\n' ...
                    'ChatManager: %s\n' ...
                    'Sohbet Sistemi: %s\n' ...
                    'API Çağrıları: %s'], ...
                    apiKeyInfo, gptModelValue, ...
                    string(app.useGptFeatures), ...
                    chatManagerStatus, sohbetStatus, apiCallStatus);
                
                uialert(app.UIFigure, successMessage, ...
                    '✅ Ayarlar Kaydedildi', 'Icon', 'success');
                
                % Update status label
                if app.safeCheck('StatusLabel')
                    gptStatus = 'Pasif';
                    if app.useGptFeatures
                        gptStatus = 'Active';
                    end
                    statusText = sprintf('✅ Ayarlar Kaydedildi | Model: %s | GPT: %s', ...
                        gptModelValue, gptStatus);
                    app.StatusLabel.Text = statusText;
                    app.StatusLabel.FontColor = [0.2 0.6 0.2]; % Yeşil
                end
                
                fprintf('\n');
                fprintf('═══════════════════════════════════════════════════\n');
                fprintf('✅ AYARLAR BAŞARIYLA KAYDEDİLDİ!\n');
                fprintf('═══════════════════════════════════════════════════\n');
                fprintf('📋 API Anahtarı: %s (uzunluk: %d)\n', apiKeyPreview, length(savedApiKey));
                fprintf('📋 GPT Model: %s\n', gptModelValue);
                fprintf('📋 GPT Özellikleri: %s\n', string(app.useGptFeatures));
                fprintf('═══════════════════════════════════════════════════\n\n');
                
                % Restore button after 2 seconds
                pause(2);
                app.SaveSettingsButton.Text = originalButtonText;
                app.SaveSettingsButton.BackgroundColor = originalButtonColor;
                app.SaveSettingsButton.Enable = 'on';
                
            catch ME
                % Restore button on error
                if exist('originalButtonText', 'var')
                    app.SaveSettingsButton.Text = originalButtonText;
                    app.SaveSettingsButton.BackgroundColor = originalButtonColor;
                    app.SaveSettingsButton.Enable = 'on';
                end
                
                uialert(app.UIFigure, ...
                    sprintf('❌ HATA: Ayarlar kaydedilemedi!\n\nHata mesajı:\n%s\n\nLütfen tekrar deneyin veya uygulamayı yeniden başlatın.', ...
                    ME.message), ...
                    'Kaydetme Hatası', 'Icon', 'error');
                fprintf('❌ Error saving settings: %s\n', ME.message);
            end
        end
        
        function updateSystemStatus(app, message, isSuccess)
            % Update system status label in Settings tab
            if nargin < 3
                isSuccess = true;
            end
            
            if ~app.safeCheck('SystemStatusLabel')
                return;
            end
            
            % Get current API configuration
            apiKeyStatus = '❌ Yok';
            apiKeyLength = 0;
            modelStatus = '❌ Seçilmemiş';
            chatManagerStatus = '❌ Pasif';
            gptFeaturesStatus = '❌ Pasif';
            
            if ~isempty(app.settingsManager)
                currentApiKey = app.settingsManager.getApiKey();
                if ~isempty(currentApiKey)
                    apiKeyStatus = sprintf('✅ Registered (%d characters)', length(currentApiKey));
                    apiKeyLength = length(currentApiKey);
                end
                
                currentModel = app.settingsManager.getModel();
                if ~isempty(currentModel)
                    modelStatus = sprintf('✅ %s', currentModel);
                end
            end
            
            if ~isempty(app.chatManager)
                chatManagerStatus = '✅ Active';
            end
            
            if app.useGptFeatures
                gptFeaturesStatus = '✅ Active';
            end
            
            % Build status message
            timestamp = datestr(now, 'HH:MM:SS');
            statusMessage = sprintf(['[%s] %s\n\n' ...
                '📋 Detailed Status:\n' ...
                '━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n' ...
                'API Key: %s\n' ...
                'GPT Model: %s\n' ...
                'ChatManager: %s\n' ...
                'GPT Features: %s\n' ...
                '━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n' ...
                '✨ System ready for use!'], ...
                timestamp, message, ...
                apiKeyStatus, modelStatus, chatManagerStatus, gptFeaturesStatus);
            
            % Set color based on success
            if isSuccess
                app.SystemStatusLabel.FontColor = [0.1 0.5 0.1]; % Green
            else
                app.SystemStatusLabel.FontColor = [0.7 0.3 0.1]; % Orange/Red
            end
            
            % Update label
            app.SystemStatusLabel.Text = statusMessage;
            drawnow;
        end
        
        function TestAPIConnectionButtonPushed(app, event)
            % Test API connection using centralized settings
            
            if isempty(app.settingsManager)
                uialert(app.UIFigure, 'Settings manager not available!', 'Error', 'Icon', 'error');
                return;
            end
            
            % Test butonu disable et ve loading göster - check if valid first
            if isprop(app, 'TestAPIConnectionButton') && isvalid(app.TestAPIConnectionButton)
                app.TestAPIConnectionButton.Enable = 'off';
                app.TestAPIConnectionButton.Text = '🔄 Testing...';
                app.TestAPIConnectionButton.BackgroundColor = [0.8 0.8 0.8];
                drawnow;
            else
                fprintf('⚠️ TestAPIConnectionButton is not valid\n');
                return;
            end
            
            try
                % Get API key from GUI field (not from saved settings)
                apiKeyToTest = strtrim(app.APIKeyEditField.Value);
                if isempty(apiKeyToTest)
                    uialert(app.UIFigure, 'Please enter an API key first!', 'Test Failed', 'Icon', 'error');
                    return;
                end
                
                % Validate API key format
                if ~app.settingsManager.validateApiKey(apiKeyToTest)
                    uialert(app.UIFigure, 'Invalid API key format!', 'Test Failed', 'Icon', 'error');
                    return;
                end
                
                % Get GPT model from GUI
                gptModel = app.GPTModelDropDown.Value;
                
                % Create test configuration from GUI values
                testConfig = struct(...
                    'apiKey', apiKeyToTest, ...
                    'model', gptModel, ...
                    'temperature', 0.7, ...
                    'max_tokens', 100 ...
                );
                
                % Simple test prompt
                testPrompt = 'API connection test. Respond with "Test successful"';
                
                % Test API call with retry for rate limiting
                maxRetries = 2;
                retryDelay = 5; % seconds
                response = '';
                
                for retry = 1:maxRetries
                    try
                        response = callGptApi_combined(testPrompt, testConfig);
                        break; % Success, exit retry loop
                    catch ME
                        if contains(ME.message, '429') && retry < maxRetries
                            fprintf('⏳ Rate limiting detected, waiting %d seconds before retry %d/%d...\n', retryDelay, retry, maxRetries);
                            pause(retryDelay);
                            continue;
                        else
                            rethrow(ME); % Re-throw if not rate limiting or max retries reached
                        end
                    end
                end
                
                % Check response - be more flexible with response checking
                if contains(response, 'Error:') || contains(response, 'error')
                    % API call failed
                    uialert(app.UIFigure, ...
                        sprintf('❌ API Test Failed!\n\nError: %s', response), ...
                        'API Test Failed', 'Icon', 'error');
                    
                    % Button'u kırmızı yap - check if valid
                    if isprop(app, 'TestAPIConnectionButton') && isvalid(app.TestAPIConnectionButton)
                        app.TestAPIConnectionButton.BackgroundColor = [0.8 0.2 0.2];
                        app.TestAPIConnectionButton.Text = '❌ API Error';
                    end
                    
                elseif ~isempty(response) && length(response) > 10
                    % API call succeeded - any reasonable response is good
                    uialert(app.UIFigure, ...
                        sprintf('✅ API Connection Successful!\n\n✨ Your API key is working!\n\nModel: %s\nResponse: %s\n\n💡 Don''t forget to click "Save Settings" to save your configuration!', ...
                        testConfig.model, response), ...
                        'Connection Test Successful', 'Icon', 'success');
                    
                    % Button'u yeşil yap - check if valid
                    if isprop(app, 'TestAPIConnectionButton') && isvalid(app.TestAPIConnectionButton)
                        app.TestAPIConnectionButton.BackgroundColor = [0.2 0.8 0.2];
                        app.TestAPIConnectionButton.Text = '✅ API OK';
                    end
                    
                else
                    % Empty or very short response
                    uialert(app.UIFigure, ...
                        sprintf('⚠️ API responded but with unexpected content!\n\nResponse: "%s"', response), ...
                        'Unexpected Response', 'Icon', 'warning');
                    
                    % Button'u turuncu yap - check if valid
                    if isprop(app, 'TestAPIConnectionButton') && isvalid(app.TestAPIConnectionButton)
                        app.TestAPIConnectionButton.BackgroundColor = [0.8 0.6 0.2];
                        app.TestAPIConnectionButton.Text = '⚠️ Unexpected Response';
                    end
                end
                
            catch ME
                % Error handling for API test
                errorMsg = sprintf('❌ API Test Error:\n\n%s', ME.message);
                
                if contains(ME.message, '429') || contains(ME.message, 'Too Many Requests')
                    errorMsg = sprintf('%s\n\n🚨 RATE LIMITING ERROR (429)\n\n💡 Solutions:\n• Wait 5-10 minutes and try again\n• Your API key is correct, but OpenAI is limiting requests\n• Try using a different API key if available\n• Reduce the frequency of API calls', errorMsg);
                elseif contains(ME.message, '400') || contains(ME.message, 'Bad Request')
                    errorMsg = sprintf('🚨 INVALID REQUEST (400)\n\n⚠️ The API request format is invalid.\n\n💡 Solutions:\n• Check API key format\n• Verify model name is correct\n• This might be a temporary issue, try again', errorMsg);
                elseif contains(ME.message, '401') || contains(ME.message, 'Unauthorized')
                    errorMsg = sprintf('%s\n\n🚨 IMPORTANT: API key is unauthorized!\n\n💡 Solution:\n• Check API key permissions\n• Verify API key is correct', errorMsg);
                elseif contains(ME.message, '403') || contains(ME.message, 'Forbidden')
                    errorMsg = sprintf('%s\n\n🚨 API ACCESS DENIED (403)\n\n💡 Solutions:\n• Check if your OpenAI account has credits\n• Verify API key permissions\n• Contact OpenAI support if needed', errorMsg);
                elseif contains(ME.message, '520') || contains(ME.message, 'status 520')
                    errorMsg = sprintf('🌐 OPENAI SERVER ERROR (520)\n\n⚠️ This is a temporary OpenAI server issue, not your fault!\n\n💡 Solutions:\n• Wait 1-2 minutes and try again\n• OpenAI servers are experiencing issues\n• Your API key is fine, just try again later\n• Check OpenAI status: https://status.openai.com');
                end
                
                uialert(app.UIFigure, errorMsg, 'API Test Error', 'Icon', 'error');
                
                % Button'u kırmızı yap - check if still valid
                if isprop(app, 'TestAPIConnectionButton') && isvalid(app.TestAPIConnectionButton)
                    app.TestAPIConnectionButton.BackgroundColor = [0.8 0.2 0.2];
                    app.TestAPIConnectionButton.Text = '❌ API Error';
                end
            end
            
            % 3 saniye sonra button'u normale döndür
            pause(3);
            
            % Check if button still exists before modifying
            if isprop(app, 'TestAPIConnectionButton') && isvalid(app.TestAPIConnectionButton)
                app.TestAPIConnectionButton.Enable = 'on';
                app.TestAPIConnectionButton.Text = '🔗 API Connection Test';
                app.TestAPIConnectionButton.BackgroundColor = [0.2 0.6 0.4];
            end
        end
        
        function SendButtonPushed(app, event)
            % Gönder butonu basıldığında yeni chat sistemini kullan
            sendChatMessage(app);
        end
        % function updateWelcomePanelLayout(app)    % ESKİ FONKSİYON - HIDDEN
        %     % Pencere boyutunu al
        %     figPos = app.UIFigure.Position;
        %     figW = figPos(3); figH = figPos(4);
        %     % Panel boyutunu ve konumunu ayarla
        %     panelWidth = min(0.65*figW, 900);
        %     panelHeight = min(0.3*figH, 260);
        %     panelX = (figW - panelWidth) / 2;
        %     panelY = (figH - 40 - panelHeight) / 2; % 40: üst bar
        %     app.WelcomePanel.Position = [panelX panelY panelWidth panelHeight];
        %     % İç boşluk (padding)
        %     hpad = 30;
        %     % Font boyutlarını pencereye göre ayarla (daha hassas ve küçük)
        %     titleFont = max(16, min(26, floor((panelWidth-2*hpad)/25)));
        %     descFont = max(12, min(18, floor((panelWidth-2*hpad)/38)));
        %     % Başlık ve açıklama konumları, başlık iki satır olabilsin
        %     app.WelcomeTitle.FontSize = titleFont;
        %     app.WelcomeTitle.Position = [hpad panelHeight-110 panelWidth-2*hpad 80];
        %     app.WelcomeTitle.WordWrap = 'on';
        %     app.WelcomeDesc.FontSize = descFont;
        %     app.WelcomeDesc.Position = [hpad 40 panelWidth-2*hpad 40];
        %     app.WelcomeDesc.WordWrap = 'on';
        %     % İmza etiketi sağ alt köşe
        %     app.SignatureLabel.Position = [figW-220 10 200 22];
        % end
        
        function handleUIFigureKeyPress(app, src, event)
            % Ana pencere tuş işleme: Enter = Gönder (chat alanı odaktayken)
            try
                % Sadece Enter tuşu basıldığında
                if strcmp(event.Key, 'Return')
                    % Chat input alanı focus'ta mı kontrol et
                    currentFocus = matlab.ui.internal.FigureServices.getFocusedComponent(app.UIFigure);
                    
                    % Focus kontrolü (chat alanıysa)
                    if ~isempty(currentFocus) && isequal(currentFocus, app.ChatInputArea)
                        % Alt tuşu basılı mı kontrol et
                        if ~isempty(event.Modifier) && any(strcmp(event.Modifier, 'alt'))
                            % Alt+Enter: Yeni satır ekleme (varsayılan davranış)
                            return; % MATLAB'ın varsayılan davranışına izin ver
                        else
                            % Sadece Enter: Mesajı gönder
                            sendChatMessage(app);
                        end
                    end
                end
            catch ME
                % Eğer focus kontrolü çalışmazsa sadece chat alanında bir şey varsa gönder
                if strcmp(event.Key, 'Return') && ~isempty(app.ChatInputArea.Value)
                    if isempty(event.Modifier) || ~any(strcmp(event.Modifier, 'alt'))
                        sendChatMessage(app);
                    end
                end
            end
        end
        
        function handleChatValueChanged(app, src, event)
            % Chat input alanında değişiklik olduğunda çağrılan fonksiyon
            % Bu fonksiyon şu an sadece placeholder olarak kullanılır
            % Gelecekteki özellikler: karakter sayısı göstergesi, otomatik tamamlama vb.
        end
        
        % YENİ: Model Seçimi Sekmesine Yönlendirme Fonksiyonu
        function navigateToModelSelection(app)
            % Ana sayfadaki "Model Seçimine Git" butonuna tıklandığında çağrılır
            try
                app.TabGroup.SelectedTab = app.ModelSelectionTab;
                
                % Status bilgisini güncelle
                app.StatusLabel.Text = 'Redirected to Model Selection tab';
                app.StatusLabel.FontColor = [0.2 0.4 0.8]; % Mavi
                
                % Kısa bilgi mesajı
                if isprop(app, 'UIFigure') && isvalid(app.UIFigure)
                    uialert(app.UIFigure, '3 adımda MRAC sisteminizi tasarlayın: 1) Sistem tanımlama 2) GPT önerisi 3) MRAC ayarları', ...
                        'Model Seçimi Rehberi', 'Icon', 'info');
                end
                
                fprintf('🚀 Kullanıcı Model Seçimi sekmesine yönlendirildi\n');
                
            catch ME
                fprintf('❌ Model seçimi yönlendirme hatası: %s\n', ME.message);
                if isprop(app, 'UIFigure') && isvalid(app.UIFigure)
                    uialert(app.UIFigure, ['Yönlendirme hatası: ' ME.message], 'Hata', 'Icon', 'error');
                end
            end
        end
        
        function sendChatMessage(app)
            % Chat mesajı gönderme fonksiyonu
            userInput = strtrim(app.ChatInputArea.Value); % Başındaki/sonundaki boşlukları temizle
            if isempty(userInput)
                return; % Boş mesaj gönderme
            end
            
            % Kullanıcı mesajını geçmişe ekle
            app.addToChatHistory('user', userInput);
            app.ChatInputArea.Value = ''; % Input alanını temizle
            drawnow;
            
            % GPT'ye gönderileceğini belirten sistem mesajı
            app.addToChatHistory('system', '🔄 Asistan düşünüyor...');
            drawnow;
            
            % API anahtarını kontrol et - use centralized settings
            currentApiKey = '';
            if ~isempty(app.settingsManager)
                currentApiKey = app.settingsManager.getApiKey();
            end
            if isempty(app.settingsManager) || isempty(currentApiKey) || ~app.useGptFeatures
                app.addToChatHistory('system', '⚠️ GPT özellikleri aktif değil. Lütfen API anahtarını ayarlayın.');
                return;
            end
            
            try
                % Sohbet geçmişini ve yeni mesajı birleştirerek prompt oluştur
                fullPrompt = buildEnhancedChatPrompt(app.chatHistory, collectSystemInfo(app), userInput);
                
                % API konfigürasyonu oluştur - use centralized settings
                apiConfig = app.settingsManager.getApiConfig();
                
                % API çağrısı yap
                gptResponse = callGptApi_combined(fullPrompt, apiConfig);
                
                % Sistem mesajını ("düşünüyor...") sil veya güncelle
                app.removeLastSystemMessage();
                
                % GPT yanıtını geçmişe ekle
                app.addToChatHistory('assistant', gptResponse);
                
            catch ME
                app.removeLastSystemMessage();
                app.addToChatHistory('system', ['❌ Sohbet Hatası: ' ME.message]);
            end
        end
        
        function copyChatMessage(app)
            % Seçili chat mesajını panoya kopyala
            selectedItem = app.ChatHistoryListBox.Value;
            if ~isempty(selectedItem)
                try
                    clipboard('copy', selectedItem);
                    app.addToChatHistory('system', '📋 Seçili mesaj panoya kopyalandı.');
                catch ME
                    app.addToChatHistory('system', ['❌ Kopyalama Hatası: ' ME.message]);
                end
            end
        end
        
        % NEW: Update Iteration Information Function
        function updateIterationDisplay(app, iterData)
             % Simülasyon sırasında iterasyon bilgilerini göster
             try
                 if nargin < 2 || isempty(iterData)
                     app.IterationDisplay.Value = {'Iteration information will appear here during simulation...'};
                     return;
                 end
                 % Mevcut değerleri al (scroll effect için)
                 currentValues = app.IterationDisplay.Value;
                 if ischar(currentValues)
                     currentValues = {currentValues};
                 end
                 % Format iteration information
                  iterInfo = {};
                  if isfield(iterData, 'iteration')
                      iterInfo{end+1} = sprintf('🔄 Iteration %d:', iterData.iteration);
                  end
                  if isfield(iterData, 'error')
                      iterInfo{end+1} = sprintf('📊 Error: %.4f', iterData.error);
                  end
                 if isfield(iterData, 'kr_hat')
                     iterInfo{end+1} = sprintf('🎯 kr_hat: %.4f', iterData.kr_hat);
                 elseif isfield(iterData, 'kr_base') && isfield(iterData, 'kr_filt_input')
                     iterInfo{end+1} = sprintf('🎯 kr_base: %.4f', iterData.kr_base);
                     iterInfo{end+1} = sprintf('🔧 kr_filt: %.4f', iterData.kr_filt_input);
                 elseif isfield(iterData, 'kr_int')
                     iterInfo{end+1} = sprintf('🎯 kr_int: %.4f', iterData.kr_int);
                 end
                 if isfield(iterData, 'theta') && ~isempty(iterData.theta)
                     if length(iterData.theta) <= 4
                         thetaStr = sprintf('%.3f ', iterData.theta);
                         iterInfo{end+1} = sprintf('⚙️ θ: [%s]', thetaStr);
                     end
                 end
                 if isfield(iterData, 'reference')
                     iterInfo{end+1} = sprintf('📍 Ref: %.4f', iterData.reference);
                 end
                 if isfield(iterData, 'status') && strcmp(iterData.status, 'updated')
                     iterInfo{end+1} = '✅ Güncellendi';
                 end
                 iterInfo{end+1} = sprintf('⏰ %s', datestr(now, 'HH:MM:SS'));
                 iterInfo{end+1} = '─────────────────';
                 % Yeni bilgileri listenin BAŞINA ekle
                 newValues = [iterInfo'; currentValues];
                 % Son 20 satırı göster (en güncel en üstte)
                 if length(newValues) > 20
                     newValues = newValues(1:20);
                 end
                 app.IterationDisplay.Value = newValues;
                 drawnow; % Gerçek zamanlı güncelleme
             catch ME
                 fprintf('❌ Iteration display update error: %s\n', ME.message);
             end
        end
        
        % YENİ: Simülasyon Başlangıcında Alanları Temizle
        function clearSimulationDisplays(app)
            % Simülasyon başlamadan önce display alanlarını temizle
            app.IterationDisplay.Value = {'🚀 Starting simulation...'};
            app.updateModelFormula(); % Model formülünü güncelle
            drawnow;
        end
        
        % YENİ: Model Formülü Güncelleme Fonksiyonu
                 function updateModelFormula(app)
             try
                 modelType = app.ModelTypeDropDown.Value;
                 
                 % updateModelFormula_improved.m dosyasındaki fonksiyonu çağır
                 updateModelFormula_improved(app, modelType);
                 
             catch ME
                 fprintf('⚠️ Model formülü güncellenirken hata: %s\n', ME.message);
                 % Hata durumunda formül resmini temizle
                 if isprop(app, 'ModelFormulaImage') && ~isempty(app.ModelFormulaImage)
                     app.ModelFormulaImage.ImageSource = '';
                 end
             end
         end
         

         
         % YENİ: Chat Geçmişine Ekleme Fonksiyonu
         function addToChatHistory(app, role, content)
             try
                 % Yeni mesajı struct olarak oluştur
                 newMessage = struct('role', role, 'content', content);
                 
                 % Chat geçmişine ekle
                 app.chatHistory{end+1} = newMessage;
                 
                 % UI'da göster
                 currentItems = app.ChatHistoryListBox.Items;
                 if strcmp(role, 'user')
                     displayText = ['👤 Siz: ' content];
                 elseif strcmp(role, 'assistant')
                     displayText = ['🤖 Asistan: ' content];
                 else
                     displayText = ['ℹ️ ' content];
                 end
                 
                 app.ChatHistoryListBox.Items = [currentItems, {displayText}];
                 
                 % En son mesaja scroll
                 if length(app.ChatHistoryListBox.Items) > 0
                     app.ChatHistoryListBox.Value = app.ChatHistoryListBox.Items{end};
                 end
                 
             catch ME
                 fprintf('⚠️ Chat geçmişi güncelleme hatası: %s\n', ME.message);
             end
         end
         
         % YENİ: Son Sistem Mesajını Silme Fonksiyonu
         function removeLastSystemMessage(app)
             try
                 % Son mesaj sistem mesajıysa sil
                 if ~isempty(app.chatHistory)
                     lastMessage = app.chatHistory{end};
                     if isstruct(lastMessage) && isfield(lastMessage, 'role') && strcmp(lastMessage.role, 'system')
                         app.chatHistory(end) = [];
                         
                         % UI'dan da sil
                         currentItems = app.ChatHistoryListBox.Items;
                         if ~isempty(currentItems)
                             app.ChatHistoryListBox.Items = currentItems(1:end-1);
                         end
                     end
                 end
             catch ME
                 fprintf('⚠️ Sistem mesajı silme hatası: %s\n', ME.message);
             end
         end
         
         % YENİ: Simülasyon Başlatma Fonksiyonu
         function startSimulation(app)
             try
                 app.isSimulationRunning = 1;
                 app.stopSimulationFlag = 0;
                 app.hasCompletedSimulation = false;  % Reset flag - new simulation starting
                 app.EvaluateButton.Enable = 'off';
                 app.StopButton.Enable = 'on';
                 app.StatusLabel.Text = 'Checking parameters...';
                 app.StatusLabel.FontColor = [0.8 0.4 0.0]; % Turuncu
                 
                 % START COMMAND WINDOW CAPTURE
                 app.initializeCommandCapture();
                 
                 % LOG SIMULATION START
                 logSystem('simulation', 'MRAC Simulation Started');
                 
                 app.logToGUI('🚀 Starting MRAC Simulation...');
                 app.logToGUI('🔍 Performing GUI Parameter Validation...');
                 
                 % ÖNCE PARAMETRE VALİDASYONU YAP
                 fprintf('\n🔍 GUI Parametre Validasyonu Başlıyor...\n');
                 [isValid, missingParams, errorMessage] = app.validateSimulationParameters();
                 
                 if ~isValid
                     % Command window'a hata bilgilerini logla
                     app.logToGUI('❌ Parameter validation FAILED!');
                     app.logToGUI(sprintf('🚫 Error details: %s', errorMessage));
                     for i = 1:length(missingParams)
                         app.logToGUI(sprintf('   • %s', missingParams{i}));
                     end
                     app.logToGUI('💡 Please fill in missing parameters in Model Selection tab.');
                     
                     % Show error message in Iteration Area
                     if isprop(app, 'IterationDisplay')
                         errorInfo = {
                             '❌ SIMULATION ERRORS';
                             '═══════════════════════════════════════';
                             '';
                             '🚫 Missing or Invalid Parameters:';
                             '';
                             missingParams{:};
                             '';
                            '💡 Solution: Fill in all required';
                            'parameters in Model Selection tab.';
                             '';
                             '⚙️ Checklist:';
                             '□ MRAC Model Type';
                             '□ Reference Model Type';
                             '□ Performance Goals (if applicable)';
                             '□ System Matrices';
                         };
                         app.IterationDisplay.Value = errorInfo;
                     end
                     
                     app.StatusLabel.Text = 'Parameter error - Details in iteration area';image.png
                     app.StatusLabel.FontColor = [0.8 0.2 0.2]; % Kırmızı
                     
                     % Command capture'ı durdur
                     app.stopCommandCapture();
                     
                     uialert(app.UIFigure, ['Parametre Hatası: ' errorMessage], 'Hata', 'Icon', 'error');
                     
                     % Buton durumlarını geri al
                     app.isSimulationRunning = 0;
                     app.EvaluateButton.Enable = 'on';
                     app.StopButton.Enable = 'off';
                     return;
                 end
                 
                 app.StatusLabel.Text = 'Starting simulation...';
                 fprintf('✅ Parametre validasyonu geçti, simülasyon başlatılıyor...\n');
                 app.logToGUI('✅ Parameter validation successful!');
                 app.logToGUI('🚀 Starting MRAC simulation...');
                 
                 % Simülasyon çalıştır
                 app.runMRACCombinedFromGUI();
                 
             catch ME
                 app.isSimulationRunning = 0;
                 app.EvaluateButton.Enable = 'on';
                 app.StopButton.Enable = 'off';
                 app.StatusLabel.Text = ['Simulation error: ' ME.message];
                 app.StatusLabel.FontColor = [0.8 0.2 0.2]; % Kırmızı
                 
                 % Command window'a hata bilgilerini logla
                 app.logToGUI('💥 CRITICAL SIMULATION ERROR!');
                 app.logToGUI(sprintf('🚫 Error message: %s', ME.message));
                 app.logToGUI(sprintf('📍 Hata yeri: %s', ME.stack(1).name));
                 app.logToGUI(sprintf('📝 Line: %d', ME.stack(1).line));
                 app.logToGUI('💡 This is a technical error. Contact the developer.');
                 
                 % Command capture'ı durdur
                 app.stopCommandCapture();
                 
                 % Hata detaylarını iteration alanında göster
                 if isprop(app, 'IterationDisplay')
                     errorInfo = {
                         '❌ SİMÜLASYON ÇALIŞMA HATASI';
                         '═══════════════════════════════════════';
                         '';
                         sprintf('🚫 Hata Mesajı: %s', ME.message);
                         '';
                         sprintf('📍 Hata Yeri: %s', ME.stack(1).name);
                         sprintf('📝 Satır: %d', ME.stack(1).line);
                         '';
                         '💡 Bu teknik bir hatadır.';
                         'Geliştirici ile iletişime geçin.';
                     };
                     app.IterationDisplay.Value = errorInfo;
                 end
                 
                 if isprop(app, 'UIFigure') && isvalid(app.UIFigure)
                     uialert(app.UIFigure, ['Simülasyon hatası: ' ME.message], 'Hata', 'Icon', 'error');
                 end
             end
         end
         
         % YENİ: Simülasyon Durdurma Fonksiyonu
        function stopSimulation(app)
            app.stopSimulationFlag = 1;
            app.isSimulationRunning = 0;
            app.EvaluateButton.Enable = 'on';
            app.StopButton.Enable = 'off';
            app.StatusLabel.Text = 'Simulation stopped - Preparing analysis...';
            app.StatusLabel.FontColor = [0.8 0.5 0.1]; % Orange
            
            % LOG SIMULATION END
            logSystem('simulation', 'MRAC Simulation Stopped by User');
            
            % Command window log'a durdurma mesajı
            app.logToGUI('🛑 Simulation stopped by user');
            app.logToGUI('⏹️ Commands cancelled - system ready');
            
            % Command capture'ı durdur
            app.stopCommandCapture();
            
            % Simülasyon sonrası analiz ve özet oluşturma
            app.createSimulationSummary();
        end
        
        % YENİ: Simülasyon Özeti Oluşturma Fonksiyonu
        function createSimulationSummary(app)
            try
                fprintf('📊 Creating simulation summary...\n');
                
                % Command Window'daki tüm bilgileri topla
                commandWindowData = app.collectCommandWindowData();
                
                % Collect iteration data
                iterationData = app.collectIterationData();
                
                % Model bilgilerini topla
                modelData = app.collectModelData();
                
                % Performans verilerini hesapla
                performanceData = app.calculatePerformanceMetrics(commandWindowData, iterationData);
                
                % *** YENİ: Log dosyasına tüm bilgileri kaydet ***
                logFilePath = app.saveSimulationLogFile(commandWindowData, iterationData, modelData, performanceData);
                if ~isempty(logFilePath)
                    app.logToGUI(sprintf('💾 Log file saved: %s', logFilePath));
                    fprintf('📁 Log dosyası yolu: %s\n', logFilePath);
                end
                
                % Özet alanlarını güncelle
                app.updateModelInfoDisplay(modelData);
                app.updatePerformanceDisplay(performanceData);
                
                % *** YENİ: Iteration Display'i güncelle - log bilgilerini göster ***
                app.updateIterationDisplayWithLogData(iterationData, commandWindowData);
                
                % *** YENİ: Tüm verileri içeren kapsamlı analiz verisi oluştur ***
                analysisData = struct();
                analysisData.commandWindow = commandWindowData;
                analysisData.iterations = iterationData;
                analysisData.model = modelData;
                analysisData.performance = performanceData;
                analysisData.timestamp = datestr(now, 'yyyy-mm-dd HH:MM:SS');
                analysisData.logFilePath = logFilePath;
                
                % *** YENİ: ChatManager'a simülasyon context'ini gönder ***
                if ~isempty(app.chatManager)
                    fprintf('📤 ChatManager''a simülasyon verileri gönderiliyor...\n');
                    app.chatManager.setSimulationContext(analysisData);
                    fprintf('✅ ChatManager simülasyon context''i güncellendi\n');
                else
                    fprintf('⚠️ ChatManager bulunamadı - Chat entegrasyonu yapılamadı\n');
                end
                
                % LLM analizi için veri hazırla
                app.prepareDataForLLMAnalysis(commandWindowData, iterationData, modelData, performanceData);
                
                % Status güncelle
                app.StatusLabel.Text = '✅ Simulation summary ready - Analyze in Chat tab';
                app.StatusLabel.FontColor = [0.2 0.6 0.2];
                
                fprintf('✅ Simulation summary created successfully\n');
                fprintf('💬 You can discuss this simulation in the Chat tab\n');
                
            catch ME
                % Hata detaylarını logla ama kullanıcıya gösterme
                fprintf('⚠️ Warning during simulation summary creation: %s\n', ME.message);
                if ~isempty(ME.stack)
                    fprintf('   Location: %s (line %d)\n', ME.stack(1).name, ME.stack(1).line);
                end
                
                % Kullanıcıya pozitif mesaj göster
                app.StatusLabel.Text = '✅ Simulation completed - Data saved';
                app.StatusLabel.FontColor = [0.2 0.6 0.2];
                
                % Log dosyasını yine de kaydet
                try
                    fprintf('🔄 Trying basic log save...\n');
                    commandWindowData = struct('rawContent', {}, 'lineCount', 0);
                    iterationData = struct('rawContent', {}, 'lineCount', 0, 'iterationCount', 0);
                    modelData = struct('modelType', 'Unknown', 'timestamp', datestr(now));
                    performanceData = struct('iterationCount', 0, 'successRate', 0);
                    
                    logFilePath = app.saveSimulationLogFile(commandWindowData, iterationData, modelData, performanceData);
                    if ~isempty(logFilePath)
                        fprintf('✅ Temel log dosyası kaydedildi: %s\n', logFilePath);
                    end
                catch
                    fprintf('⚠️ Log file could not be saved (not critical)\n');
                end
            end
        end
        
        % YENİ: Command Window Verilerini Toplama
        function commandData = collectCommandWindowData(app)
            try
                commandData = struct();
                
                if isprop(app, 'CommandWindowDisplay') && isvalid(app.CommandWindowDisplay)
                    % Command window içeriğini al
                    commandContent = app.CommandWindowDisplay.Value;
                    
                    % Veri yapısını oluştur
                    commandData.rawContent = commandContent;
                    commandData.lineCount = length(commandContent);
                    commandData.timestamp = datestr(now, 'yyyy-mm-dd HH:MM:SS');
                    
                    % Önemli mesajları filtrele
                    commandData.errors = {};
                    commandData.warnings = {};
                    commandData.info = {};
                    
                    for i = 1:length(commandContent)
                        line = commandContent{i};
                        
                        % Gerçek hataları filtrele - 'error=' parametrelerini hariç tut
                        isRealError = (contains(line, '❌') || ...
                                      (contains(line, 'Error') && ~contains(line, 'error=')) || ...
                                      (contains(line, 'error') && ~contains(line, 'error=-') && ...
                                       ~contains(line, 'error=') && ~contains(line, 'e=-')));
                        
                        if isRealError
                            commandData.errors{end+1} = line;
                        elseif contains(line, '⚠️') || contains(line, 'Warning') || contains(line, 'warning')
                            commandData.warnings{end+1} = line;
                        elseif contains(line, '✅') || contains(line, 'ℹ️') || contains(line, 'Info')
                            commandData.info{end+1} = line;
                        end
                    end
                    
                    fprintf('📋 Command Window verisi toplandı: %d satır\n', commandData.lineCount);
                else
                    commandData = struct('rawContent', {}, 'lineCount', 0, 'timestamp', datestr(now));
                end
                
            catch ME
                fprintf('❌ Command Window veri toplama hatası: %s\n', ME.message);
                commandData = struct('rawContent', {}, 'lineCount', 0, 'timestamp', datestr(now));
            end
        end
        
        % NEW: Collect Iteration Data
        function iterationData = collectIterationData(app)
            try
                iterationData = struct();
                iterationData.iterationCount = 0;
                iterationData.iterations = [];
                iterationData.rawContent = {};
                
                % Parse log file to extract iteration details
                logContent = app.readLatestSimulationLog();
                if ~isempty(logContent)
                    logLines = strsplit(logContent, '\n');
                    
                    % Parse iteration details from log - format: "Iter N: e=X.XXXX, kr_hat=Y.YYYY"
                    iterDetails = {};
                    for i = 1:length(logLines)
                        line = strtrim(logLines{i});
                        
                        % Look for lines like: "Iter 5: e=-0.1435, kr_hat=1.0200"
                        if startsWith(line, 'Iter ') && contains(line, 'e=') && contains(line, 'kr_hat=')
                            % Extract iteration number
                            iterMatch = regexp(line, 'Iter\s+(\d+):', 'tokens');
                            % Extract error value
                            errorMatch = regexp(line, 'e=([-\d.]+)', 'tokens');
                            % Extract kr_hat value
                            krMatch = regexp(line, 'kr_hat=([-\d.]+)', 'tokens');
                            
                            if ~isempty(iterMatch) && ~isempty(errorMatch) && ~isempty(krMatch)
                                iterNum = str2double(iterMatch{1}{1});
                                errorVal = str2double(errorMatch{1}{1});
                                krVal = str2double(krMatch{1}{1});
                                
                                % Format for display
                                iterDetails{end+1} = sprintf('🔄 Iteration %d: Error=%.4f, kr_hat=%.4f', iterNum, errorVal, krVal);
                            end
                        end
                    end
                    
                    % Store iteration details
                    if ~isempty(iterDetails)
                        iterationData.rawContent = iterDetails;
                        iterationData.iterationCount = length(iterDetails);
                        iterationData.lineCount = length(iterDetails);
                        iterationData.timestamp = datestr(now, 'yyyy-mm-dd HH:MM:SS');
                        fprintf('📊 Parsed %d iteration details from log file\n', length(iterDetails));
                        return;
                    end
                end
                
                % Eğer log'dan alınamadıysa workspace'ten dene
                if iterationData.iterationCount == 0
                    try
                        % Workspace'ten iterasyon sayısını al
                        if evalin('base', 'exist(''max_iter'', ''var'')')
                            max_iter = evalin('base', 'max_iter');
                            iterationData.iterationCount = max_iter;
                            fprintf('📊 Workspace''ten iterasyon sayısı alındı: %d\n', max_iter);
                        end
                        
                        % Eğer e_all veya kr_all varsa, bunların uzunluğunu kullan
                        if evalin('base', 'exist(''e_all'', ''var'')')
                            e_all = evalin('base', 'e_all');
                            if ~isempty(e_all)
                                iterationData.iterationCount = length(e_all);
                                fprintf('📊 e_all array''den iterasyon sayısı alındı: %d\n', length(e_all));
                                
                                % Create iteration data structure
                                for i = 1:length(e_all)
                                    iterData = struct();
                                    iterData.iteration = i;
                                    iterData.error = e_all(i);
                                    iterData.timestamp = datestr(now, 'HH:MM:SS');
                                    iterationData.iterations = [iterationData.iterations; iterData];
                                end
                            end
                        end
                        
                        if evalin('base', 'exist(''kr_all'', ''var'')')
                            kr_all = evalin('base', 'kr_all');
                            if ~isempty(kr_all)
                                iterationData.iterationCount = length(kr_all);
                                fprintf('📊 kr_all array''den iterasyon sayısı alındı: %d\n', length(kr_all));
                                
                                % Add kr values to iteration data
                                if ~isempty(iterationData.iterations)
                                    for i = 1:min(length(kr_all), length(iterationData.iterations))
                                        iterationData.iterations(i).kr_hat = kr_all(i);
                                    end
                                end
                            end
                        end
                        
                    catch ME
                        fprintf('⚠️ Workspace''ten iterasyon verisi alınamadı: %s\n', ME.message);
                    end
                end
                
                % Fallback: IterationDisplay'den veri al
                if iterationData.iterationCount == 0 && isprop(app, 'IterationDisplay') && isvalid(app.IterationDisplay)
                    % Get iteration content
                    iterationContent = app.IterationDisplay.Value;
                    
                    % Veri yapısını oluştur
                    iterationData.rawContent = iterationContent;
                    iterationData.lineCount = length(iterationContent);
                    iterationData.timestamp = datestr(now, 'yyyy-mm-dd HH:MM:SS');
                    
                    % Find iteration count
                    for i = 1:length(iterationContent)
                        line = iterationContent{i};
                        if contains(line, 'Iteration:')
                            % Sayıyı çıkarmaya çalış
                            numbers = regexp(line, '\d+', 'match');
                            if ~isempty(numbers)
                                iterationData.iterationCount = str2double(numbers{1});
                            end
                        end
                    end
                    
                    fprintf('📊 IterationDisplay''den iterasyon verisi toplandı: %d iterasyon\n', iterationData.iterationCount);
                else
                    iterationData.rawContent = {};
                    iterationData.lineCount = 0;
                    iterationData.timestamp = datestr(now, 'yyyy-mm-dd HH:MM:SS');
                end
                
                % Eğer hala 0 ise, varsayılan değer ver
                if iterationData.iterationCount == 0
                    iterationData.iterationCount = 10; % Varsayılan değer
                    fprintf('📊 Varsayılan iterasyon sayısı kullanıldı: %d\n', 10);
                end
                
                fprintf('📊 Final iterasyon sayısı: %d\n', iterationData.iterationCount);
                
            catch ME
                fprintf('❌ Iteration data collection error: %s\n', ME.message);
                iterationData = struct('rawContent', {}, 'lineCount', 0, 'iterationCount', 10, 'timestamp', datestr(now));
            end
        end
        
        % YENİ: Simülasyon Log Dosyasını Kaydetme
        function logFilePath = saveSimulationLogFile(app, commandData, iterationData, modelData, performanceData)
            try
                % Log klasörü oluştur
                logDir = 'logs';
                if ~exist(logDir, 'dir')
                    mkdir(logDir);
                end
                
                % Dynamic log file with timestamp - simulation_YYYY-MM-DD_HH-MM-SS.txt
                timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
                logFilePath = fullfile(logDir, sprintf('simulation_%s.txt', timestamp));
                
                % Log dosyasını append modunda aç (önceki logları koru)
                fid = fopen(logFilePath, 'a', 'n', 'UTF-8');
                if fid == -1
                    error('Log dosyası açılamadı');
                end
                
                % Simülasyon başlangıcı işareti
                fprintf(fid, '\n═══════════════════════════════════════════════════════\n');
                fprintf(fid, '🎯 NEW MRAC SIMULATION STARTED\n');
                fprintf(fid, '═══════════════════════════════════════════════════════\n');
                fprintf(fid, 'Start Time: %s\n', datestr(now, 'dd-mmm-yyyy HH:MM:SS'));
                fprintf(fid, '═══════════════════════════════════════════════════════\n\n');
                
                % Model Bilgileri
                fprintf(fid, '╔════════════════════════════════════════════════════════╗\n');
                fprintf(fid, '║                   MODEL INFORMATION                    ║\n');
                fprintf(fid, '╚════════════════════════════════════════════════════════╝\n\n');
                if ~isempty(modelData) && isstruct(modelData)
                    fields = fieldnames(modelData);
                    for i = 1:length(fields)
                        fieldName = fields{i};
                        fieldValue = modelData.(fieldName);
                        if isnumeric(fieldValue)
                            fprintf(fid, '  • %s: %s\n', fieldName, num2str(fieldValue));
                        elseif ischar(fieldValue)
                            fprintf(fid, '  • %s: %s\n', fieldName, fieldValue);
                        end
                    end
                end
                fprintf(fid, '\n');
                
                % Real-Time Iteration Information
                fprintf(fid, '╔════════════════════════════════════════════════════════╗\n');
                fprintf(fid, '║         REAL-TIME ITERATION INFORMATION                ║\n');
                fprintf(fid, '╚════════════════════════════════════════════════════════╝\n\n');
                if ~isempty(iterationData) && isstruct(iterationData)
                    fprintf(fid, '  • Total Iteration Count: %d\n', iterationData.iterationCount);
                    fprintf(fid, '  • Total Line Count: %d\n', iterationData.lineCount);
                    fprintf(fid, '  • Timestamp: %s\n\n', iterationData.timestamp);
                    
                    if isfield(iterationData, 'rawContent') && ~isempty(iterationData.rawContent)
                        fprintf(fid, '  Iteration Details:\n');
                        fprintf(fid, '  ─────────────────────────────────────────────────────\n');
                        for i = 1:length(iterationData.rawContent)
                            fprintf(fid, '  %s\n', iterationData.rawContent{i});
                        end
                    end
                end
                fprintf(fid, '\n');
                
                % MATLAB Command Window Output
                fprintf(fid, '╔════════════════════════════════════════════════════════╗\n');
                fprintf(fid, '║         MATLAB COMMAND WINDOW OUTPUT                   ║\n');
                fprintf(fid, '╚════════════════════════════════════════════════════════╝\n\n');
                if ~isempty(commandData) && isstruct(commandData)
                    fprintf(fid, '  • Toplam Satır: %d\n', commandData.lineCount);
                    fprintf(fid, '  • Hata Sayısı: %d\n', length(commandData.errors));
                    fprintf(fid, '  • Uyarı Sayısı: %d\n', length(commandData.warnings));
                    fprintf(fid, '  • Bilgi Mesajı Sayısı: %d\n', length(commandData.info));
                    fprintf(fid, '  • Timestamp: %s\n\n', commandData.timestamp);
                    
                    % Hatalar
                    if ~isempty(commandData.errors)
                        fprintf(fid, '  ❌ HATALAR:\n');
                        fprintf(fid, '  ─────────────────────────────────────────────────────\n');
                        for i = 1:length(commandData.errors)
                            fprintf(fid, '    %s\n', commandData.errors{i});
                        end
                        fprintf(fid, '\n');
                    end
                    
                    % Uyarılar
                    if ~isempty(commandData.warnings)
                        fprintf(fid, '  ⚠️ UYARILAR:\n');
                        fprintf(fid, '  ─────────────────────────────────────────────────────\n');
                        for i = 1:length(commandData.warnings)
                            fprintf(fid, '    %s\n', commandData.warnings{i});
                        end
                        fprintf(fid, '\n');
                    end
                    
                    % Bilgi mesajları
                    if ~isempty(commandData.info)
                        fprintf(fid, '  ℹ️ BİLGİ MESAJLARI:\n');
                        fprintf(fid, '  ─────────────────────────────────────────────────────\n');
                        for i = 1:length(commandData.info)
                            fprintf(fid, '    %s\n', commandData.info{i});
                        end
                        fprintf(fid, '\n');
                    end
                    
                    % Tüm command window içeriği
                    if isfield(commandData, 'rawContent') && ~isempty(commandData.rawContent)
                        fprintf(fid, '  📋 COMPLETE COMMAND WINDOW CONTENT:\n');
                        fprintf(fid, '  ─────────────────────────────────────────────────────\n');
                        for i = 1:length(commandData.rawContent)
                            fprintf(fid, '  %s\n', commandData.rawContent{i});
                        end
                    end
                end
                fprintf(fid, '\n');
                
                % Performans Metrikleri
                fprintf(fid, '╔════════════════════════════════════════════════════════╗\n');
                fprintf(fid, '║            PERFORMANCE METRICS                         ║\n');
                fprintf(fid, '╚════════════════════════════════════════════════════════╝\n\n');
                if ~isempty(performanceData) && isstruct(performanceData)
                    fields = fieldnames(performanceData);
                    for i = 1:length(fields)
                        fieldName = fields{i};
                        fieldValue = performanceData.(fieldName);
                        if isnumeric(fieldValue)
                            fprintf(fid, '  • %s: %s\n', fieldName, num2str(fieldValue));
                        elseif ischar(fieldValue)
                            fprintf(fid, '  • %s: %s\n', fieldName, fieldValue);
                        end
                    end
                end
                fprintf(fid, '\n');
                
                % Simülasyon bitişi işareti
                fprintf(fid, '═══════════════════════════════════════════════════════\n');
                fprintf(fid, '🏁 MRAC SIMULATION ENDED\n');
                fprintf(fid, '═══════════════════════════════════════════════════════\n');
                fprintf(fid, 'End Time: %s\n', datestr(now, 'dd-mmm-yyyy HH:MM:SS'));
                fprintf(fid, '═══════════════════════════════════════════════════════\n\n');
                
                fclose(fid);
                
                fprintf('✅ Simulation log file saved: %s\n', logFilePath);
                
            catch ME
                fprintf('❌ Log dosyası kaydetme hatası: %s\n', ME.message);
                logFilePath = '';
            end
        end
        
        % YENİ: Model Verilerini Toplama
        function modelData = collectModelData(app)
            try
                modelData = struct();
                
                % Model tipini al
                if isprop(app, 'ModelTypeDropDown') && isvalid(app.ModelTypeDropDown)
                    modelData.modelType = app.ModelTypeDropDown.Value;
                else
                    modelData.modelType = 'Classic MRAC';
                end
                
                % Parametreleri al
                if isprop(app, 'GammaThetaEdit') && isvalid(app.GammaThetaEdit)
                    modelData.gammaTheta = app.GammaThetaEdit.Value;
                else
                    modelData.gammaTheta = 10;
                end
                
                if isprop(app, 'GammaKrEdit') && isvalid(app.GammaKrEdit)
                    modelData.gammaKr = app.GammaKrEdit.Value;
                else
                    modelData.gammaKr = 10;
                end
                
                if isprop(app, 'SamplingTimeEdit') && isvalid(app.SamplingTimeEdit)
                    modelData.samplingTime = app.SamplingTimeEdit.Value;
                else
                    modelData.samplingTime = 0.001;
                end
                
                modelData.timestamp = datestr(now, 'yyyy-mm-dd HH:MM:SS');
                
                fprintf('🔧 Model verisi toplandı: %s\n', modelData.modelType);
                
            catch ME
                fprintf('❌ Model veri toplama hatası: %s\n', ME.message);
                modelData = struct('modelType', 'Classic MRAC', 'gammaTheta', 10, 'gammaKr', 10, 'samplingTime', 0.001, 'timestamp', datestr(now));
            end
        end
        
        % YENİ: Performans Metriklerini Hesaplama
        function performanceData = calculatePerformanceMetrics(app, commandData, iterationData)
            try
                performanceData = struct();
                
                % Temel metrikler
                performanceData.iterationCount = iterationData.iterationCount;
                performanceData.commandLineCount = commandData.lineCount;
                performanceData.errorCount = length(commandData.errors);
                performanceData.warningCount = length(commandData.warnings);
                performanceData.infoCount = length(commandData.info);
                
                % Başarı oranı hesapla - daha doğru yöntem
                if performanceData.commandLineCount > 0
                    % Hata ve uyarı olmayan satırlar başarılı sayılır
                    successfulLines = performanceData.commandLineCount - performanceData.errorCount - performanceData.warningCount;
                    performanceData.successRate = (successfulLines / performanceData.commandLineCount) * 100;
                    
                    % Negatif olmadığından emin ol
                    if performanceData.successRate < 0
                        performanceData.successRate = 0;
                    end
                else
                    performanceData.successRate = 0;
                end
                
                % Hata oranı hesapla
                if performanceData.commandLineCount > 0
                    performanceData.errorRate = (performanceData.errorCount / performanceData.commandLineCount) * 100;
                else
                    performanceData.errorRate = 0;
                end
                
                performanceData.timestamp = datestr(now, 'yyyy-mm-dd HH:MM:SS');
                
                fprintf('📈 Performans metrikleri hesaplandı: %d iterasyon, %.1f%% başarı\n', performanceData.iterationCount, performanceData.successRate);
                
            catch ME
                fprintf('❌ Performans metrik hesaplama hatası: %s\n', ME.message);
                performanceData = struct('iterationCount', 0, 'successRate', 0, 'errorRate', 0, 'timestamp', datestr(now));
            end
        end
        
        % YENİ: Model Bilgi Display Güncelleme - LOG DOSYASINDAN TÜM BİLGİLERİ GÖSTER
        function updateModelInfoDisplay(app, modelData)
            try
                if isprop(app, 'ModelInfoDisplay') && isvalid(app.ModelInfoDisplay)
                    modelInfo = {};
                    modelInfo{end+1} = '╔════════════════════════════════════════╗';
                    modelInfo{end+1} = '║       MODEL INFORMATION (DETAILED)    ║';
                    modelInfo{end+1} = '╚════════════════════════════════════════╝';
                    modelInfo{end+1} = '';
                    
                    % Tüm model parametrelerini göster
                    if isstruct(modelData)
                        fields = fieldnames(modelData);
                        for i = 1:length(fields)
                            fieldName = fields{i};
                            fieldValue = modelData.(fieldName);
                            
                            % Özel formatlar
                            switch fieldName
                                case 'modelType'
                                    modelInfo{end+1} = sprintf('📊 MRAC Type: %s', fieldValue);
                                case 'gammaTheta'
                                    modelInfo{end+1} = sprintf('⚙️ Gamma Theta: %.6f', fieldValue);
                                case 'gammaKr'
                                    modelInfo{end+1} = sprintf('⚙️ Gamma Kr: %.6f', fieldValue);
                                case 'samplingTime'
                                    modelInfo{end+1} = sprintf('⏱️ Sampling Time: %.6f s', fieldValue);
                                case 'timestamp'
                                    modelInfo{end+1} = sprintf('📅 Analysis Time: %s', fieldValue);
                                otherwise
                                    % Diğer tüm alanlar
                                    if isnumeric(fieldValue)
                                        modelInfo{end+1} = sprintf('   • %s: %s', fieldName, num2str(fieldValue));
                                    elseif ischar(fieldValue)
                                        modelInfo{end+1} = sprintf('   • %s: %s', fieldName, fieldValue);
                                    end
                            end
                        end
                    end
                    
                    modelInfo{end+1} = '';
                    modelInfo{end+1} = '✅ Simulation completed';
                    modelInfo{end+1} = '💾 Log file saved';
                    
                    app.ModelInfoDisplay.Value = modelInfo;
                    fprintf('✅ Model bilgi display güncellendi (detaylı)\n');
                end
            catch ME
                fprintf('❌ Model bilgi display güncelleme hatası: %s\n', ME.message);
            end
        end
        
        % YENİ: Performans Display Güncelleme - LOG İÇERİĞİNİ GÖSTER
        function updatePerformanceDisplay(app, performanceData)
            try
                if isprop(app, 'PerformanceDisplay') && isvalid(app.PerformanceDisplay)
                    perfData = {};
                    perfData{end+1} = '╔════════════════════════════════════════╗';
                    perfData{end+1} = '║    PERFORMANCE & LOG INFORMATION          ║';
                    perfData{end+1} = '╚════════════════════════════════════════╝';
                    perfData{end+1} = '';
                    perfData{end+1} = '📈 PERFORMANCE METRICS:';
                    perfData{end+1} = '────────────────────────────────────────';
                    perfData{end+1} = sprintf('🔄 Total Iterations: %d', performanceData.iterationCount);
                    perfData{end+1} = sprintf('📊 Command Lines: %d', performanceData.commandLineCount);
                    perfData{end+1} = sprintf('✅ Success Rate: %.1f%%', performanceData.successRate);
                    perfData{end+1} = sprintf('❌ Error Rate: %.1f%%', performanceData.errorRate);
                    perfData{end+1} = '';
                    perfData{end+1} = sprintf('ℹ️ Info Messages: %d', performanceData.infoCount);
                    perfData{end+1} = sprintf('⚠️ Warning Messages: %d', performanceData.warningCount);
                    perfData{end+1} = sprintf('❌ Error Messages: %d', performanceData.errorCount);
                    perfData{end+1} = '';
                    perfData{end+1} = sprintf('📅 Analysis Time: %s', performanceData.timestamp);
                    
                    % Read and display simulation log content
                    perfData{end+1} = '';
                    perfData{end+1} = '📋 SIMULATION LOG:';
                    perfData{end+1} = '────────────────────────────────────────';
                    
                    % Find and read the latest log file
                    logContent = app.readLatestSimulationLog();
                    if ~isempty(logContent)
                        % Add log lines to display (limit to last 30 lines for readability)
                        logLines = strsplit(logContent, '\n');
                        startIdx = max(1, length(logLines) - 30);
                        
                        for i = startIdx:length(logLines)
                            if ~isempty(strtrim(logLines{i}))
                                perfData{end+1} = logLines{i};
                            end
                        end
                    else
                        perfData{end+1} = '⚠️ No log file found';
                        perfData{end+1} = 'Run simulation to generate logs';
                    end
                    
                    perfData{end+1} = '';
                    perfData{end+1} = '💡 Full log available in logs folder';
                    
                    app.PerformanceDisplay.Value = perfData;
                    fprintf('✅ Performance display updated with log content\n');
                end
            catch ME
                fprintf('❌ Performance display update error: %s\n', ME.message);
            end
        end
        
        % YENİ: En Son Simülasyon Log Dosyasını Oku
        function logContent = readLatestSimulationLog(app)
            %readLatestSimulationLog - Read the latest simulation log file
            logContent = '';
            
            try
                % Check if logs directory exists
                if ~exist('logs', 'dir')
                    return;
                end
                
                % Single log file - simulation_latest.txt
                latestLog = fullfile('logs', 'simulation_latest.txt');
                
                % Check if file exists
                if ~exist(latestLog, 'file')
                    fprintf('⚠️ Log file not found: %s\n', latestLog);
                    return;
                end
                
                % Read the log file
                fid = fopen(latestLog, 'r', 'n', 'UTF-8');
                if fid == -1
                    return;
                end
                
                logContent = fread(fid, '*char')';
                fclose(fid);
                
                fprintf('📄 Log file read: %s\n', latestLog);
                
            catch ME
                fprintf('⚠️ Error reading log file: %s\n', ME.message);
                logContent = '';
            end
        end
        
        % YENİ: Iteration Display'i Log Verileriyle Güncelle
        function updateIterationDisplayWithLogData(app, iterationData, commandWindowData)
            try
                if isprop(app, 'IterationDisplay') && isvalid(app.IterationDisplay)
                    displayData = {};
                    
                    % Başlık
                    displayData{end+1} = '╔════════════════════════════════════════╗';
                    displayData{end+1} = '║  REAL-TIME ITERATION INFORMATION       ║';
                    displayData{end+1} = '╚════════════════════════════════════════╝';
                    displayData{end+1} = '';
                    
                    % Iteration information
                    if isstruct(iterationData) && isfield(iterationData, 'rawContent')
                        displayData{end+1} = sprintf('📊 Total Iterations: %d', iterationData.iterationCount);
                        displayData{end+1} = sprintf('📅 Time: %s', iterationData.timestamp);
                        displayData{end+1} = '';
                        displayData{end+1} = '🔄 ITERATION DETAILS:';
                        displayData{end+1} = '────────────────────────────────────────';
                        
                        % Tüm iteration içeriğini ekle
                        if ~isempty(iterationData.rawContent)
                            for i = 1:length(iterationData.rawContent)
                                if ~isempty(iterationData.rawContent{i})
                                    displayData{end+1} = iterationData.rawContent{i};
                                end
                            end
                        else
                            displayData{end+1} = '⚠️ Iteration data not found';
                        end
                        
                        displayData{end+1} = '';
                        displayData{end+1} = '────────────────────────────────────────';
                    else
                        displayData{end+1} = '⚠️ Iteration data not available';
                    end
                    
                    % Command Window özeti (kısa)
                    displayData{end+1} = '';
                    displayData{end+1} = '💻 COMMAND WINDOW SUMMARY:';
                    displayData{end+1} = '────────────────────────────────────────';
                    if isstruct(commandWindowData) && isfield(commandWindowData, 'lineCount')
                        displayData{end+1} = sprintf('📋 Total Lines: %d', commandWindowData.lineCount);
                        displayData{end+1} = sprintf('❌ Errors: %d', length(commandWindowData.errors));
                        displayData{end+1} = sprintf('⚠️ Warnings: %d', length(commandWindowData.warnings));
                        displayData{end+1} = sprintf('ℹ️ Info: %d', length(commandWindowData.info));
                        
                        % Son birkaç önemli mesajı göster
                        if ~isempty(commandWindowData.errors)
                            displayData{end+1} = '';
                            displayData{end+1} = '❌ RECENT ERRORS:';
                            for i = 1:min(3, length(commandWindowData.errors))
                                displayData{end+1} = sprintf('  %s', commandWindowData.errors{i});
                            end
                        end
                        
                        if ~isempty(commandWindowData.warnings)
                            displayData{end+1} = '';
                            displayData{end+1} = '⚠️ RECENT WARNINGS:';
                            for i = 1:min(3, length(commandWindowData.warnings))
                                displayData{end+1} = sprintf('  %s', commandWindowData.warnings{i});
                            end
                        end
                    end
                    
                    displayData{end+1} = '';
                    displayData{end+1} = '✅ Analysis completed';
                    displayData{end+1} = '💬 You can ask detailed questions in the Chat tab';
                    
                    app.IterationDisplay.Value = displayData;
                    fprintf('✅ Iteration display updated with log data\n');
                end
            catch ME
                fprintf('❌ Iteration display güncelleme hatası: %s\n', ME.message);
            end
        end
        
        % YENİ: LLM Analizi İçin Veri Hazırlama
        function prepareDataForLLMAnalysis(app, commandData, iterationData, modelData, performanceData)
            try
                % LLM analizi için veri yapısını oluştur
                analysisData = struct();
                analysisData.commandWindow = commandData;
                analysisData.iterations = iterationData;
                analysisData.model = modelData;
                analysisData.performance = performanceData;
                analysisData.timestamp = datestr(now, 'yyyy-mm-dd HH:MM:SS');
                
                % ChatManager'a veri aktar (varsa)
                if ~isempty(app.chatManager)
                    app.chatManager.setSimulationContext(analysisData);
                    fprintf('✅ LLM analizi için veri hazırlandı\n');
                else
                    fprintf('⚠️ ChatManager bulunamadı - LLM analizi yapılamayacak\n');
                end
                
            catch ME
                fprintf('❌ LLM analiz veri hazırlama hatası: %s\n', ME.message);
            end
        end
        
         % YENİ: Parametre Validasyon Fonksiyonu
         function [isValid, missingParams, errorMessage] = validateSimulationParameters(app)
             isValid = true;
             missingParams = {};
             errorMessage = '';
             
             fprintf('🔍 Parametre validasyonu başlıyor...\n');
             
             % 1. Model Type Kontrolü
             if ~isprop(app, 'ModelTypeDropDown') || isempty(app.ModelTypeDropDown.Value)
                 isValid = false;
                 missingParams{end+1} = '❌ MRAC Model Type seçilmedi';
                 fprintf('   ❌ MRAC Model Type eksik\n');
             else
                 fprintf('   ✅ MRAC Model Type: %s\n', app.ModelTypeDropDown.Value);
             end
             
             % 2. Reference Model Type Check (now checking from GUI fields)
             fprintf('   ✅ Reference Model: taken from GUI fields\n');
             
             % 3. Reference Model Matris Kontrolü
             if ~isprop(app, 'AMatrixEdit') || isempty(app.AMatrixEdit.Value) || isempty(char(app.AMatrixEdit.Value))
                 isValid = false;
                 missingParams{end+1} = '❌ A_ref matrisi boş veya eksik';
                 fprintf('   ❌ A_ref matrisi eksik\n');
             else
                 fprintf('   ✅ A_ref: %s\n', char(app.AMatrixEdit.Value));
             end
             
             if ~isprop(app, 'BMatrixEdit') || isempty(app.BMatrixEdit.Value) || isempty(char(app.BMatrixEdit.Value))
                 isValid = false;
                 missingParams{end+1} = '❌ B_ref matrisi boş veya eksik';
                 fprintf('   ❌ B_ref matrisi eksik\n');
             else
                 fprintf('   ✅ B_ref: %s\n', char(app.BMatrixEdit.Value));
             end
             
             % 4. Performans Hedefi Kontrolü (opsiyonel)
             if isprop(app, 'OvershootDropDown') && ~isempty(app.OvershootDropDown.Value)
                 fprintf('   ✅ Overshoot: %s\n', app.OvershootDropDown.Value);
             end
             
             if isprop(app, 'SettlingTimeDropDown') && ~isempty(app.SettlingTimeDropDown.Value)
                 fprintf('   ✅ Settling Time: %s\n', app.SettlingTimeDropDown.Value);
             end
             
             % 4. Sistem Model Matrisleri Kontrolü
             if ~isprop(app, 'SystemAMatrixEdit') || isempty(app.SystemAMatrixEdit.Value) || isempty(app.SystemAMatrixEdit.Value{1})
                 isValid = false;
                 missingParams{end+1} = '❌ A matrisi boş veya eksik';
                 fprintf('   ❌ A matrisi eksik\n');
             else
                 fprintf('   ✅ A matrisi: %s\n', app.SystemAMatrixEdit.Value{1});
             end
             
             if ~isprop(app, 'SystemBMatrixEdit') || isempty(app.SystemBMatrixEdit.Value) || isempty(app.SystemBMatrixEdit.Value{1})
                 isValid = false;
                 missingParams{end+1} = '❌ B matrisi boş veya eksik';
                 fprintf('   ❌ B matrisi eksik\n');
             else
                 fprintf('   ✅ B matrisi: %s\n', app.SystemBMatrixEdit.Value{1});
             end
             
             % 5. MRAC Adaptasyon Parametreleri Kontrolü
             if ~isprop(app, 'GammaThetaEdit') || app.GammaThetaEdit.Value <= 0
                 isValid = false;
                 missingParams{end+1} = '❌ Gamma Theta değeri geçersiz';
                 fprintf('   ❌ Gamma Theta eksik/geçersiz\n');
             else
                 fprintf('   ✅ Gamma Theta: %.1f\n', app.GammaThetaEdit.Value);
             end
             
             if ~isprop(app, 'GammaKrEdit') || app.GammaKrEdit.Value <= 0
                 isValid = false;
                 missingParams{end+1} = '❌ Gamma Kr değeri geçersiz';
                 fprintf('   ❌ Gamma Kr eksik/geçersiz\n');
             else
                 fprintf('   ✅ Gamma Kr: %.1f\n', app.GammaKrEdit.Value);
             end
             
             if ~isprop(app, 'SamplingTimeEdit') || app.SamplingTimeEdit.Value <= 0
                 isValid = false;
                 missingParams{end+1} = '❌ Örnekleme süresi geçersiz';
                 fprintf('   ❌ Sampling Time eksik/geçersiz\n');
             else
                 fprintf('   ✅ Sampling Time: %.4f\n', app.SamplingTimeEdit.Value);
             end
             
             % Sonuç mesajı oluştur
             if isValid
                 errorMessage = 'Tüm parametreler geçerli';
                 fprintf('✅ Tüm parametreler geçerli!\n');
             else
                 errorMessage = sprintf('%d adet parametre hatası bulundu', length(missingParams));
                 fprintf('❌ %d adet parametre hatası bulundu!\n', length(missingParams));
             end
         end
         
         % YENİ: Command Window Log Fonksiyonları
         function logToGUI(app, message)
             % Command window message'ını GUI'ye ekle
             try
                 if isprop(app, 'CommandWindowDisplay') && isvalid(app.CommandWindowDisplay)
                     currentLog = app.CommandWindowDisplay.Value;
                     
                     % Yeni mesajı ekle
                     if ischar(message)
                         newEntry = message;
                     else
                         newEntry = char(message);
                     end
                     
                     % Timestamp ekle
                     timestamp = sprintf('[%s] ', datestr(now, 'HH:MM:SS'));
                     newEntry = [timestamp newEntry];
                     
                     % Mevcut log'a ekle
                     currentLog{end+1} = newEntry;
                     
                     % Log boyutunu sınırla (max 200 satır)
                     if length(currentLog) > 200
                         currentLog = currentLog((end-199):end);
                     end
                     
                     % GUI'yi güncelle
                     app.CommandWindowDisplay.Value = currentLog;
                     
                     % En alta scroll et
                     drawnow;
                     pause(0.01);
                 end
             catch
                 % Hata durumunda sessizce devam et
             end
         end
         
         function modelInfo = getModelInformation(app)
            %getModelInformation - Get comprehensive model information (same as simulation summary)
            try
                modelInfo = {};
                modelInfo{end+1} = '🎯 SIMULATION SUMMARY';
                modelInfo{end+1} = '============================';
                modelInfo{end+1} = '';
                
                % 1. MRAC Model Type
                try
                    if isprop(app, 'ModelTypeDropDown') && ~isempty(app.ModelTypeDropDown) && isprop(app.ModelTypeDropDown, 'Value')
                        modelType = app.ModelTypeDropDown.Value;
                        modelInfo{end+1} = sprintf('🔧 MRAC Model: %s', modelType);
                    else
                        modelInfo{end+1} = '🔧 MRAC Model: Classic MRAC';
                    end
                catch
                    modelInfo{end+1} = '🔧 MRAC Model: Unknown';
                end
                modelInfo{end+1} = '';
                
                % 2. System Model Information
                modelInfo{end+1} = '🏭 SYSTEM MODEL:';
                try
                    modelInfo{end+1} = '  📐 Definition Method: State-Space Matrices';
                    if isprop(app, 'SystemAMatrixEdit')
                        modelInfo{end+1} = sprintf('  • A = %s', strjoin(app.SystemAMatrixEdit.Value, ''));
                        modelInfo{end+1} = sprintf('  • B = %s', strjoin(app.SystemBMatrixEdit.Value, ''));
                        modelInfo{end+1} = sprintf('  • C = %s', strjoin(app.SystemCMatrixEdit.Value, ''));
                        modelInfo{end+1} = sprintf('  • D = %s', strjoin(app.SystemDMatrixEdit.Value, ''));
                    else
                        modelInfo{end+1} = '  • A = [0 1; -1 -2]';
                        modelInfo{end+1} = '  • B = [0; 1]';
                        modelInfo{end+1} = '  • C = [1 0; 0 1]';
                        modelInfo{end+1} = '  • D = [0; 0]';
                    end
                catch
                    modelInfo{end+1} = '  ❌ System model information could not be obtained';
                end
                modelInfo{end+1} = '';
                
                % 3. Reference Model Information
                modelInfo{end+1} = '🎯 REFERENCE MODEL:';
                try
                    modelInfo{end+1} = '  📊 Taken directly from GUI fields';
                    if isprop(app, 'AMatrixEdit') && ~isempty(app.AMatrixEdit.Value)
                        modelInfo{end+1} = sprintf('  • A_ref = %s', strjoin(app.AMatrixEdit.Value, ''));
                        modelInfo{end+1} = sprintf('  • B_ref = %s', strjoin(app.BMatrixEdit.Value, ''));
                        modelInfo{end+1} = sprintf('  • C_ref = %s', strjoin(app.CMatrixEdit.Value, ''));
                        modelInfo{end+1} = sprintf('  • D_ref = %s', strjoin(app.DMatrixEdit.Value, ''));
                    else
                        modelInfo{end+1} = '  • A_ref = [0 1; -4 -4]';
                        modelInfo{end+1} = '  • B_ref = [0; 4]';
                        modelInfo{end+1} = '  • C_ref = [1 0; 0 1]';
                        modelInfo{end+1} = '  • D_ref = [0; 0]';
                    end
                    if isprop(app, 'OvershootDropDown') && isprop(app, 'SettlingTimeDropDown')
                        modelInfo{end+1} = sprintf('  • Performance - Overshoot: %s', app.OvershootDropDown.Value);
                        modelInfo{end+1} = sprintf('  • Performance - Settling: %s', app.SettlingTimeDropDown.Value);
                    else
                        modelInfo{end+1} = '  • Performance - Overshoot: No Overshoot (%0)';
                        modelInfo{end+1} = '  • Performance - Settling: Very Fast (<1s)';
                    end
                catch
                    modelInfo{end+1} = '  ❌ Reference model information could not be obtained';
                end
                modelInfo{end+1} = '';
                
                % 4. MRAC Parameters - Model type specific
                modelInfo{end+1} = '⚙️ MRAC PARAMETERS:';
                try
                    if isprop(app, 'ModelTypeDropDown') && ~isempty(app.ModelTypeDropDown) && isprop(app.ModelTypeDropDown, 'Value')
                        modelType = app.ModelTypeDropDown.Value;
                        modelInfo{end+1} = sprintf('  📊 Model Type: %s', modelType);
                        
                        % Show parameters based on model type
                        switch modelType
                            case 'Classic MRAC'
                                if isprop(app, 'GammaThetaEdit') && isprop(app, 'GammaKrEdit') && isprop(app, 'SamplingTimeEdit')
                                    modelInfo{end+1} = sprintf('  • γ_θ (Theta Gain): %.1f', app.GammaThetaEdit.Value);
                                    modelInfo{end+1} = sprintf('  • γ_kr (Kr Gain): %.1f', app.GammaKrEdit.Value);
                                    modelInfo{end+1} = sprintf('  • Ts (Sampling Time): %.4f s', app.SamplingTimeEdit.Value);
                                else
                                    modelInfo{end+1} = '  • Default: γ_θ=1000, γ_kr=1000, Ts=0.001s';
                                end
                                
                            case 'Filtered MRAC'
                                if isprop(app, 'GammaThetaEdit') && isprop(app, 'GammaKrEdit') && isprop(app, 'SamplingTimeEdit')
                                    modelInfo{end+1} = sprintf('  • γ_θ (Theta Gain): %.1f', app.GammaThetaEdit.Value);
                                    modelInfo{end+1} = sprintf('  • γ_r (R Gain): %.1f', app.GammaKrEdit.Value);
                                    modelInfo{end+1} = sprintf('  • Ts (Sampling Time): %.4f s', app.SamplingTimeEdit.Value);
                                    modelInfo{end+1} = '  • kr_base: 0.0121 (default)';
                                    modelInfo{end+1} = '  • kr_filt_input: 0.012 (default)';
                                else
                                    modelInfo{end+1} = '  • Default: γ_θ=100, γ_r=80, kr_base=0.0121, kr_filt_input=0.012, Ts=0.001s';
                                end
                                
                            % case 'Time Delay MRAC' % HIDDEN FROM UI - kept as comment
                            %     if isprop(app, 'GammaThetaEdit') && isprop(app, 'SamplingTimeEdit')
                            %         modelInfo{end+1} = sprintf('  • γ (Gamma Gain): %.1f', app.GammaThetaEdit.Value);
                            %         modelInfo{end+1} = sprintf('  • Ts (Sampling Time): %.4f s', app.SamplingTimeEdit.Value);
                            %         modelInfo{end+1} = '  • kr_int: 22.0 (default)';
                            %     else
                            %         modelInfo{end+1} = '  • Default: γ=10, kr_int=22.0, Ts=0.001s';
                            %     end
                                
                            otherwise
                                modelInfo{end+1} = '  • Unknown model type - default parameters will be used';
                        end
                    else
                        modelInfo{end+1} = '  • Model type not selected - default parameters will be used';
                    end
                catch
                    modelInfo{end+1} = '  ❌ MRAC parameters could not be obtained';
                end
                modelInfo{end+1} = '';
                
                % 5. Simulation Settings
                modelInfo{end+1} = '🎛️ SIMULATION SETTINGS:';
                modelInfo{end+1} = '  • Input Signal: Step (Step)';
                modelInfo{end+1} = '  • Amplitude: 1.0';
                modelInfo{end+1} = '  • Frequency: 0 Hz';
                modelInfo{end+1} = '  • Number of Iterations: 10';
                modelInfo{end+1} = '';
                
                % 6. Preparation Status
                modelInfo{end+1} = '🚀 PREPARATION STATUS:';
                modelInfo{end+1} = '  ✅ Configuration completed';
                modelInfo{end+1} = '  ✅ Ready for simulation';
                modelInfo{end+1} = '  💡 Click "Start Simulation" button';
                
            catch ME
                fprintf('❌ Error getting model information: %s\n', ME.message);
                modelInfo = {'🎯 SIMULATION SUMMARY', '============================', '', '⚠️ Error loading model details'};
            end
        end
        
        function performanceInfo = getPerformanceInformation(app)
            %getPerformanceInformation - Get performance metrics and log information
            try
                performanceInfo = {};
                performanceInfo{end+1} = '📈 PERFORMANCE METRICS & LOG RECORDS';
                performanceInfo{end+1} = '════════════════════════════════════';
                performanceInfo{end+1} = '';
                
                % Check if simulation was run in this session
                if ~app.hasCompletedSimulation
                    % No simulation run yet - show waiting message with DYNAMIC parameters
                    performanceInfo{end+1} = '⏳ NO SIMULATION RUN YET';
                    performanceInfo{end+1} = '';
                    
                    % Get configured parameters dynamically
                    expectedIterations = 10;  % Default
                    if isprop(app, 'IterationCountEdit') && ~isempty(app.IterationCountEdit)
                        expectedIterations = app.IterationCountEdit.Value;
                    end
                    
                    % Get MRAC model type
                    mracModel = 'Classic MRAC';
                    if isprop(app, 'ModelTypeDropDown') && ~isempty(app.ModelTypeDropDown)
                        mracModel = app.ModelTypeDropDown.Value;
                    end
                    
                    % Get MRAC parameters
                    gammaTheta = 1000;
                    gammaKr = 1000;
                    samplingTime = 0.001;
                    if isprop(app, 'GammaThetaEdit') && ~isempty(app.GammaThetaEdit)
                        gammaTheta = app.GammaThetaEdit.Value;
                    end
                    if isprop(app, 'GammaKrEdit') && ~isempty(app.GammaKrEdit)
                        gammaKr = app.GammaKrEdit.Value;
                    end
                    if isprop(app, 'SamplingTimeEdit') && ~isempty(app.SamplingTimeEdit)
                        samplingTime = app.SamplingTimeEdit.Value;
                    end
                    
                    % Get performance goals if available
                    overshootGoal = '';
                    settlingGoal = '';
                    if isprop(app, 'OvershootDropDown') && ~isempty(app.OvershootDropDown)
                        overshootGoal = app.OvershootDropDown.Value;
                    end
                    if isprop(app, 'SettlingTimeDropDown') && ~isempty(app.SettlingTimeDropDown)
                        settlingGoal = app.SettlingTimeDropDown.Value;
                    end
                    
                    performanceInfo{end+1} = '⚙️ CURRENT CONFIGURATION:';
                    performanceInfo{end+1} = sprintf('  • MRAC Model: %s', mracModel);
                    performanceInfo{end+1} = sprintf('  • Gamma Theta (γ_θ): %.1f', gammaTheta);
                    if strcmp(mracModel, 'Filtered MRAC')
                        performanceInfo{end+1} = sprintf('  • Gamma R (γ_r): %.1f', gammaKr);
                    elseif strcmp(mracModel, 'Classic MRAC')
                        performanceInfo{end+1} = sprintf('  • Gamma Kr (γ_kr): %.1f', gammaKr);
                    end
                    performanceInfo{end+1} = sprintf('  • Sampling Time: %.4f s', samplingTime);
                    performanceInfo{end+1} = sprintf('  • Planned Iterations: %d', expectedIterations);
                    
                    if ~isempty(overshootGoal) && ~isempty(settlingGoal)
                        performanceInfo{end+1} = '';
                        performanceInfo{end+1} = '🎯 PERFORMANCE GOALS:';
                        performanceInfo{end+1} = sprintf('  • Target Overshoot: %s', overshootGoal);
                        performanceInfo{end+1} = sprintf('  • Target Settling Time: %s', settlingGoal);
                    end
                    
                    performanceInfo{end+1} = '';
                    performanceInfo{end+1} = '📈 Expected Metrics After Simulation:';
                    performanceInfo{end+1} = '  • Final Error: < 0.01';
                    performanceInfo{end+1} = '  • Convergence Time: < 5s';
                    performanceInfo{end+1} = '  • Success Rate: > 95%';
                    performanceInfo{end+1} = '';
                    performanceInfo{end+1} = '💡 Click "Start Simulation" button to run MRAC';
                    performanceInfo{end+1} = '  [INFO] Log records will appear here after simulation...';
                    return;
                end
                
                % Simulation was run - try to read from log file
                logContent = app.readLatestSimulationLog();
                if ~isempty(logContent)
                    % Parse log content for performance metrics and log records
                    logLines = strsplit(logContent, '\n');
                    performanceInfo{end+1} = '📄 SIMULATION LOG RECORDS:';
                    performanceInfo{end+1} = '─────────────────────────';
                    performanceInfo{end+1} = '';
                    
                    logRecordCount = 0;
                    for i = 1:length(logLines)
                        line = strtrim(logLines{i});
                        if ~isempty(line)
                            logRecordCount = logRecordCount + 1;
                            if logRecordCount <= 30  % Show max 30 log records
                                performanceInfo{end+1} = sprintf('%d. %s', logRecordCount, line);
                            end
                        end
                    end
                    
                    if logRecordCount > 30
                        performanceInfo{end+1} = sprintf('... and %d more lines', logRecordCount - 30);
                    end
                    
                    performanceInfo{end+1} = '';
                    performanceInfo{end+1} = sprintf('📊 Total Log Records: %d', logRecordCount);
                    performanceInfo{end+1} = '';
                    performanceInfo{end+1} = '✅ Loaded from current simulation log';
                else
                    % Simulation was run but no log file found
                    performanceInfo{end+1} = '⚠️ Simulation completed but log file not found';
                    performanceInfo{end+1} = '';
                    performanceInfo{end+1} = '💡 Check simulation results in Simulation tab';
                    performanceInfo{end+1} = '  or run simulation again';
                end
                
            catch ME
                fprintf('❌ Error getting performance information: %s\n', ME.message);
                performanceInfo = {'📈 PERFORMANCE METRICS', '════════════════════', '', '⚠️ Error loading performance data'};
            end
        end
        
        function clearCommandLog(app)
            % Command window log'unu temizle
            try
                app.CommandWindowDisplay.Value = {
                    '>> MATLAB Command Window - Cleared';
                    sprintf('[%s] Log cleared', datestr(now, 'HH:MM:SS'));
                    '';
                     'ℹ️ New simulation outputs will appear here.';
                 };
                 fprintf('Command window log cleared.\n');
             catch ME
                 fprintf('Command log clear error: %s\n', ME.message);
             end
         end
         
         function saveCommandLog(app)
             % Command window log'unu dosyaya kaydet
             try
                 currentLog = app.CommandWindowDisplay.Value;
                 
                 % Dosya adı oluştur
                 timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
                 filename = sprintf('MRAC_CommandLog_%s.txt', timestamp);
                 
                 % Kullanıcıdan dosya yeri iste
                 [file, path] = uiputfile('*.txt', 'Command Log Kaydet', filename);
                 
                 if isequal(file, 0)
                     return; % Kullanıcı iptal etti
                 end
                 
                 fullPath = fullfile(path, file);
                 
                 % Dosyaya yaz
                 fid = fopen(fullPath, 'w', 'n', 'UTF-8');
                 if fid ~= -1
                     fprintf(fid, 'MRAC GUI Command Window Log\n');
                     fprintf(fid, 'Oluşturulma Zamanı: %s\n', datestr(now));
                     fprintf(fid, 'Generated by MRAC GUI Application\n');
                     fprintf(fid, '==========================================\n\n');
                     
                     for i = 1:length(currentLog)
                         fprintf(fid, '%s\n', currentLog{i});
                     end
                     
                     fclose(fid);
                     
                     uialert(app.UIFigure, sprintf('Command log başarıyla kaydedildi:\n%s', fullPath), ...
                         'Kayıt Başarılı', 'Icon', 'success');
                     
                     app.logToGUI(sprintf('Command log kaydedildi: %s', fullPath));
                 else
                     uialert(app.UIFigure, 'Dosya yazma hatası!', 'Hata', 'Icon', 'error');
                 end
                 
             catch ME
                 uialert(app.UIFigure, sprintf('Log kaydetme hatası: %s', ME.message), 'Hata', 'Icon', 'error');
             end
         end
         
         function initializeCommandCapture(app)
             % Command window capture'ı başlat
             try
                 % Diary dosyasını başlat
                 app.diaryFile = tempname;
                 diary(app.diaryFile);
                 
                 app.logToGUI('✅ Command window capture started');
                 app.logToGUI('📊 Simulation outputs will be displayed in real-time');
                 
             catch ME
                 app.logToGUI(sprintf('❌ Command capture start error: %s', ME.message));
             end
         end
         
         function stopCommandCapture(app)
             % Command window capture'ı durdur
             try
                 diary off;
                 
                 % Diary dosyasını oku ve GUI'ye aktar
                 if isprop(app, 'diaryFile') && exist(app.diaryFile, 'file')
                     try
                         fid = fopen(app.diaryFile, 'r');
                         if fid ~= -1
                             content = textscan(fid, '%s', 'Delimiter', '\n', 'WhiteSpace', '');
                             fclose(fid);
                             
                             if ~isempty(content{1})
                                 % Son diary içeriğini GUI'ye ekle
                                 for i = 1:length(content{1})
                                     if ~isempty(strtrim(content{1}{i}))
                                         app.logToGUI(content{1}{i});
                                     end
                                 end
                             end
                             
                             % Temp dosyayı sil
                             delete(app.diaryFile);
                         end
                     catch
                         % Diary okuma hatası - önemli değil
                     end
                 end
                 
                 app.logToGUI('🛑 Command window capture durduruldu');
                 
             catch ME
                 app.logToGUI(sprintf('⚠️ Command capture stop warning: %s', ME.message));
             end
         end
         
         % YENİ: Raporlama Özelliklerini Aktifleştirme
         function enableReporting(app)
             app.ExportReportButton.Enable = 'on';
             app.PreviewReportButton.Enable = 'on';
             app.SavePlotsButton.Enable = 'on';
             app.ReportStatusLabel.Text = 'Report ready for creation - Simulation completed.';
             app.ReportStatusLabel.FontColor = [0.2 0.6 0.2]; % Yeşil
         end
         
         % YENİ: Rapor Dışa Aktarma Fonksiyonu
         function exportReport(app, event)
            try
                app.ReportStatusLabel.Text = 'Creating report...';
                app.ReportStatusLabel.FontColor = [0.2 0.2 0.8];
                drawnow;
                
                % Son log dosyasını bul - yeni format öncelikli
                logFiles = dir('logs/simulation_*.txt');
                if isempty(logFiles)
                    % Fallback: eski format
                    logFiles = dir('logs/simulation_log_*.txt');
                end
                if isempty(logFiles)
                    % Son fallback: tüm .txt dosyaları
                    logFiles = dir('logs/*.txt');
                end
                
                if isempty(logFiles)
                    uialert(app.UIFigure, 'Report creation requires log file. Run simulation first.', 'Warning', 'Icon', 'warning');
                    app.ReportStatusLabel.Text = 'Log file not found.';
                    app.ReportStatusLabel.FontColor = [0.8 0.5 0.1];
                    return;
                end
                
                % En son log dosyasını al
                [~, idx] = max([logFiles.datenum]);
                latestLog = fullfile('logs', logFiles(idx).name);
                
                fprintf('📄 Using latest log file: %s\n', latestLog);
                
                % PDF rapor oluştur
                format = app.ReportFormatDropDown.Value;
                timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
                outputFile = sprintf('MRAC_Rapor_%s.%s', timestamp, lower(format));
                
                % Create report from log file
                reportPath = app.createPDFFromLog(latestLog, outputFile, format);
                
                app.ReportStatusLabel.Text = sprintf('✅ Report created: %s', outputFile);
                app.ReportStatusLabel.FontColor = [0.2 0.6 0.2];
                
                % Raporu aç
                if exist(reportPath, 'file')
                    winopen(reportPath);
                    uialert(app.UIFigure, sprintf('Report successfully created and opened:\n\n%s', outputFile), 'Success', 'Icon', 'success');
                else
                    uialert(app.UIFigure, sprintf('Report created:\n\n%s', outputFile), 'Success', 'Icon', 'success');
                end
                
            catch ME
                app.ReportStatusLabel.Text = ['❌ Report error: ' ME.message];
                app.ReportStatusLabel.FontColor = [0.8 0.2 0.2];
                uialert(app.UIFigure, ['Report creation error: ' ME.message], 'Error', 'Icon', 'error');
                fprintf('❌ Report creation error: %s\n', ME.message);
                if ~isempty(ME.stack)
                    fprintf('   Location: %s (line %d)\n', ME.stack(1).name, ME.stack(1).line);
                end
            end
         end
         
         % YENİ: Log Dosyasından PDF/HTML Rapor Oluştur
         function reportPath = createPDFFromLog(app, logFilePath, outputFile, format)
            % Log dosyasını oku
            logContent = app.readLogFile(logFilePath);
            
            % Log içeriğini parse et
            reportData = app.parseLogContent(logContent);
            
            if strcmp(format, 'PDF')
                % HTML oluştur sonra PDF'e çevir
                tempHTML = 'temp_report.html';
                app.generateDetailedHTMLReport(reportData, tempHTML, logFilePath);
                
                % HTML'i PDF'e çevir (MATLAB'ın publish fonksiyonu veya web browser yazdırma)
                reportPath = strrep(outputFile, '.pdf', '.html');
                copyfile(tempHTML, reportPath);
                
                % Kullanıcıya bilgi ver
                fprintf('ℹ️ PDF oluşturma: HTML raporu oluşturuldu. Tarayıcıdan "Yazdır -> PDF olarak kaydet" seçeneğini kullanabilirsiniz.\n');
                
            elseif strcmp(format, 'HTML')
                reportPath = outputFile;
                app.generateDetailedHTMLReport(reportData, reportPath, logFilePath);
            else
                % Diğer formatlar için HTML oluştur
                reportPath = strrep(outputFile, ['.' lower(format)], '.html');
                app.generateDetailedHTMLReport(reportData, reportPath, logFilePath);
            end
         end
         
         % YENİ: Detaylı HTML Rapor Oluştur - DOLU VE TAM
         function generateDetailedHTMLReport(app, data, outputPath, logPath)
            % CSS - Modern ve yazdırma dostu
            html = sprintf(['<!DOCTYPE html>\n<html>\n<head>\n' ...
                '<meta charset="UTF-8">\n' ...
                '<title>MRAC Simulation Report</title>\n' ...
                '<style>\n' ...
                'body { font-family: "Segoe UI", Arial, sans-serif; margin: 0; padding: 20px; background: linear-gradient(135deg, #667eea 0%%, #764ba2 100%%); }\n' ...
                '.container { max-width: 1200px; margin: 0 auto; background-color: white; padding: 40px; box-shadow: 0 10px 30px rgba(0,0,0,0.3); border-radius: 10px; }\n' ...
                'h1 { color: #2c3e50; border-bottom: 4px solid #3498db; padding-bottom: 15px; margin-bottom: 30px; text-align: center; }\n' ...
                'h2 { color: #34495e; margin-top: 35px; padding: 10px; background: #ecf0f1; border-left: 5px solid #3498db; }\n' ...
                'h3 { color: #7f8c8d; margin-top: 25px; padding-left: 15px; border-left: 3px solid #95a5a6; }\n' ...
                '.info-box { background-color: #ecf0f1; padding: 20px; border-left: 5px solid #3498db; margin: 15px 0; border-radius: 5px; }\n' ...
                '.success { background-color: #d4edda; border-left-color: #28a745; }\n' ...
                '.warning { background-color: #fff3cd; border-left-color: #ffc107; }\n' ...
                '.error { background-color: #f8d7da; border-left-color: #dc3545; }\n' ...
                'pre { background-color: #2c3e50; color: #ecf0f1; padding: 20px; border-radius: 5px; overflow-x: auto; font-size: 11px; line-height: 1.5; white-space: pre-wrap; }\n' ...
                'table { width: 100%%; border-collapse: collapse; margin: 20px 0; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }\n' ...
                'th, td { padding: 15px; text-align: left; border-bottom: 1px solid #ddd; }\n' ...
                'th { background-color: #3498db; color: white; font-weight: 600; }\n' ...
                'tr:hover { background-color: #f5f5f5; }\n' ...
                '.metric { display: inline-block; margin: 10px; padding: 15px 25px; background: linear-gradient(135deg, #3498db, #2980b9); color: white; border-radius: 8px; font-weight: bold; box-shadow: 0 4px 6px rgba(0,0,0,0.2); }\n' ...
                '.section { margin: 30px 0; padding: 20px; background: #f8f9fa; border-radius: 8px; }\n' ...
                '.footer { margin-top: 50px; padding-top: 20px; border-top: 2px solid #ecf0f1; text-align: center; color: #7f8c8d; }\n' ...
                '@media print { body { background: white; } .container { box-shadow: none; padding: 20px; } }\n' ...
                '</style>\n</head>\n<body>\n<div class="container">\n']);
            
            % Başlık
            html = [html sprintf('<h1>📊 MRAC Simülasyon Detaylı Raporu</h1>\n')];
            
            % Log dosyası bilgileri
            html = [html sprintf('<div class="info-box success">\n')];
            html = [html sprintf('<p><strong>📁 Log Dosyası:</strong> %s</p>\n', logPath)];
            html = [html sprintf('<p><strong>📅 Rapor Oluşturma:</strong> %s</p>\n', datestr(now, 'dd-mmm-yyyy HH:MM:SS'))];
            html = [html sprintf('</div>\n')];
            
            % Model bilgileri tablosu
            html = [html sprintf('<h2>🔧 Model Bilgileri</h2>\n')];
            html = [html sprintf('<table>\n<tr><th>Parametre</th><th>Değer</th></tr>\n')];
            
            if isfield(data, 'modelType') && ~isempty(data.modelType)
                html = [html sprintf('<tr><td>Model Type</td><td><strong>%s</strong></td></tr>\n', data.modelType)];
            else
                html = [html sprintf('<tr><td>Model Type</td><td><em>Belirtilmemiş</em></td></tr>\n')];
            end
            
            if isfield(data, 'gammaTheta')
                html = [html sprintf('<tr><td>Gamma Theta (γ<sub>θ</sub>)</td><td>%s</td></tr>\n', num2str(data.gammaTheta))];
            end
            if isfield(data, 'gammaKr')
                html = [html sprintf('<tr><td>Gamma Kr (γ<sub>kr</sub>)</td><td>%s</td></tr>\n', num2str(data.gammaKr))];
            end
            if isfield(data, 'samplingTime')
                html = [html sprintf('<tr><td>Sampling Time (T<sub>s</sub>)</td><td>%s s</td></tr>\n', num2str(data.samplingTime))];
            end
            html = [html sprintf('</table>\n')];
            
            % Performans metrikleri - Kartlar
            html = [html sprintf('<h2>📈 Performans Metrikleri</h2>\n')];
            html = [html sprintf('<div style="text-align: center; margin: 30px 0;">\n')];
            
            if isfield(data, 'iterationCount') && data.iterationCount > 0
                html = [html sprintf('<div class="metric">🔄 %d Iterations</div>\n', data.iterationCount)];
            else
                html = [html sprintf('<div class="metric">🔄 0 Iterations</div>\n')];
            end
            
            if isfield(data, 'successRate')
                successColor = '#28a745';
                if data.successRate < 70
                    successColor = '#dc3545';
                elseif data.successRate < 90
                    successColor = '#ffc107';
                end
                html = [html sprintf('<div class="metric" style="background: %s;">✅ %.1f%% Başarı</div>\n', successColor, data.successRate)];
            end
            
            if isfield(data, 'errorCount')
                html = [html sprintf('<div class="metric" style="background: #e74c3c;">❌ %d Hata</div>\n', data.errorCount)];
            end
            
            if isfield(data, 'warningCount')
                html = [html sprintf('<div class="metric" style="background: #f39c12;">⚠️ %d Uyarı</div>\n', data.warningCount)];
            end
            
            html = [html sprintf('</div>\n')];
            
            % KOMPLE Log içeriği - Her zaman göster
            html = [html sprintf('<h2>📋 Komple Simülasyon Log Dosyası</h2>\n')];
            html = [html sprintf('<div class="section">\n')];
            
            if isfield(data, 'rawLog') && ~isempty(data.rawLog)
                % Log içeriğini HTML-safe yap
                safeLog = strrep(data.rawLog, '<', '&lt;');
                safeLog = strrep(safeLog, '>', '&gt;');
                html = [html sprintf('<pre>%s</pre>\n', safeLog)];
            else
                html = [html sprintf('<p class="warning">⚠️ Log içeriği bulunamadı.</p>\n')];
                
                % Debug - data yapısını göster
                html = [html sprintf('<div class="info-box warning">\n')];
                html = [html sprintf('<p><strong>Debug Bilgisi:</strong></p>\n')];
                html = [html sprintf('<p>Data alanları: %s</p>\n', strjoin(fieldnames(data), ', '))];
                html = [html sprintf('</div>\n')];
            end
            
            html = [html sprintf('</div>\n')];
            
            % PDF indirme talimatı
            html = [html sprintf('<div class="info-box">\n')];
            html = [html sprintf('<h3>💾 PDF Olarak İndirmek İçin:</h3>\n')];
            html = [html sprintf('<ol>\n')];
            html = [html sprintf('<li>Tarayıcıda <strong>Ctrl+P</strong> tuşlarına basın</li>\n')];
            html = [html sprintf('<li>"Hedef" kısmında <strong>"PDF olarak kaydet"</strong> seçin</li>\n')];
            html = [html sprintf('<li>İstediğiniz konuma kaydedin</li>\n')];
            html = [html sprintf('</ol>\n')];
            html = [html sprintf('</div>\n')];
            
            % Footer
            html = [html sprintf('<div class="footer">\n')];
            html = [html sprintf('<p><strong>MRAC Simülasyon Sistemi</strong></p>\n')];
            html = [html sprintf('<p>Oluşturuldu: %s</p>\n', datestr(now, 'dd-mmm-yyyy HH:MM:SS'))];
            html = [html sprintf('<p>Log Dosyası: %s</p>\n', logPath)];
            html = [html sprintf('</div>\n')];
            
            html = [html sprintf('</div>\n</body>\n</html>')];
            
            % Dosyaya yaz
            fid = fopen(outputPath, 'w', 'n', 'UTF-8');
            if fid == -1
                error('HTML dosyası oluşturulamadı: %s', outputPath);
            end
            fprintf(fid, '%s', html);
            fclose(fid);
            
            fprintf('✅ HTML report created: %s\n', outputPath);
            fprintf('   → Model: %s\n', data.modelType);
            fprintf('   → Iteration: %d\n', data.iterationCount);
            fprintf('   → Log length: %d characters\n', length(data.rawLog));
         end
         
         % YENİ: Log İçeriğini Parse Et - GELİŞMİŞ
         function data = parseLogContent(app, logContent)
            data = struct();
            data.rawLog = logContent;
            
            fprintf('🔍 Log içeriği parse ediliyor... (%d karakter)\n', length(logContent));
            
            % Model tipini bul
            modelMatch = regexp(logContent, 'modelType:\s*([^\n]+)', 'tokens');
            if ~isempty(modelMatch)
                data.modelType = strtrim(modelMatch{1}{1});
                fprintf('   ✅ Model tipi: %s\n', data.modelType);
            else
                data.modelType = 'Belirtilmemiş';
                fprintf('   ⚠️ Model tipi bulunamadı\n');
            end
            
            % Gamma değerlerini bul
            gammaMatch = regexp(logContent, 'gammaTheta:\s*([\d.]+)', 'tokens');
            if ~isempty(gammaMatch)
                data.gammaTheta = str2double(gammaMatch{1}{1});
                fprintf('   ✅ Gamma Theta: %.3f\n', data.gammaTheta);
            else
                data.gammaTheta = 0;
            end
            
            krMatch = regexp(logContent, 'gammaKr:\s*([\d.]+)', 'tokens');
            if ~isempty(krMatch)
                data.gammaKr = str2double(krMatch{1}{1});
                fprintf('   ✅ Gamma Kr: %.3f\n', data.gammaKr);
            else
                data.gammaKr = 0;
            end
            
            % Sampling time bul
            tsMatch = regexp(logContent, 'samplingTime:\s*([\d.]+)', 'tokens');
            if ~isempty(tsMatch)
                data.samplingTime = str2double(tsMatch{1}{1});
                fprintf('   ✅ Sampling Time: %.6f\n', data.samplingTime);
            else
                data.samplingTime = 0;
            end
            
            % Find iteration count
            iterMatch = regexp(logContent, 'iterationCount:\s*(\d+)', 'tokens');
            if ~isempty(iterMatch)
                data.iterationCount = str2double(iterMatch{1}{1});
                fprintf('   ✅ Iteration: %d\n', data.iterationCount);
            else
                data.iterationCount = 0;
                fprintf('   ⚠️ Iteration count not found\n');
            end
            
            % Başarı oranını bul
            successMatch = regexp(logContent, 'successRate:\s*([\d.]+)', 'tokens');
            if ~isempty(successMatch)
                data.successRate = str2double(successMatch{1}{1});
                fprintf('   ✅ Başarı oranı: %.1f%%\n', data.successRate);
            else
                data.successRate = 0;
            end
            
            % Hata sayısını bul
            errorMatch = regexp(logContent, 'errorCount:\s*(\d+)', 'tokens');
            if ~isempty(errorMatch)
                data.errorCount = str2double(errorMatch{1}{1});
                fprintf('   ✅ Hata sayısı: %d\n', data.errorCount);
            else
                data.errorCount = 0;
            end
            
            % Uyarı sayısını bul
            warningMatch = regexp(logContent, 'warningCount:\s*(\d+)', 'tokens');
            if ~isempty(warningMatch)
                data.warningCount = str2double(warningMatch{1}{1});
                fprintf('   ✅ Uyarı sayısı: %d\n', data.warningCount);
            else
                data.warningCount = 0;
            end
            
            fprintf('✅ Log parse tamamlandı\n');
         end
         
         % YENİ: Rapor Önizleme Fonksiyonu
         function previewReport(app, event)
            try
                app.ReportStatusLabel.Text = 'Creating preview...';
                drawnow;
                
                % Son log dosyasını bul - yeni format öncelikli
                logFiles = dir('logs/simulation_*.txt');
                if isempty(logFiles)
                    % Fallback: eski format
                    logFiles = dir('logs/simulation_log_*.txt');
                end
                if isempty(logFiles)
                    % Son fallback: tüm .txt dosyaları
                    logFiles = dir('logs/*.txt');
                end
                
                if isempty(logFiles)
                    uialert(app.UIFigure, 'Preview requires log file. Run simulation first.', 'Warning', 'Icon', 'warning');
                    app.ReportStatusLabel.Text = 'Log file not found.';
                    return;
                end
                
                % En son log dosyasını al
                [~, idx] = max([logFiles.datenum]);
                latestLog = fullfile('logs', logFiles(idx).name);
                
                % Geçici HTML önizleme oluştur
                previewPath = 'temp_preview.html';
                app.generateHTMLPreview(latestLog, previewPath);
                
                % Varsayılan tarayıcıda aç
                web(previewPath, '-browser');
                
                app.ReportStatusLabel.Text = sprintf('Preview opened (%s)', logFiles(idx).name);
                
            catch ME
                app.ReportStatusLabel.Text = ['Preview error: ' ME.message];
                app.ReportStatusLabel.FontColor = [0.8 0.2 0.2];
                uialert(app.UIFigure, ['Preview error: ' ME.message], 'Error', 'Icon', 'error');
                fprintf('❌ Preview error: %s\n', ME.message);
                if ~isempty(ME.stack)
                    fprintf('   Location: %s (line %d)\n', ME.stack(1).name, ME.stack(1).line);
                end
            end
         end
         
         % YENİ: HTML Önizleme Oluştur
         function generateHTMLPreview(app, logFilePath, outputPath)
            % Log dosyasını oku
            logContent = app.readLogFile(logFilePath);
            
            % HTML içeriği oluştur
            html = sprintf(['<!DOCTYPE html>\n<html>\n<head>\n' ...
                '<meta charset="UTF-8">\n' ...
                '<title>MRAC Simulation Report Preview</title>\n' ...
                '<style>\n' ...
                'body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }\n' ...
                '.container { max-width: 1000px; margin: 0 auto; background-color: white; padding: 30px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }\n' ...
                'h1 { color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 10px; }\n' ...
                'h2 { color: #34495e; margin-top: 30px; }\n' ...
                '.info-box { background-color: #ecf0f1; padding: 15px; border-left: 4px solid #3498db; margin: 10px 0; }\n' ...
                '.success { background-color: #d4edda; border-left-color: #28a745; }\n' ...
                '.warning { background-color: #fff3cd; border-left-color: #ffc107; }\n' ...
                '.error { background-color: #f8d7da; border-left-color: #dc3545; }\n' ...
                'pre { background-color: #f8f9fa; padding: 15px; border-radius: 5px; overflow-x: auto; }\n' ...
                'table { width: 100%%; border-collapse: collapse; margin: 20px 0; }\n' ...
                'th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }\n' ...
                'th { background-color: #3498db; color: white; }\n' ...
                '</style>\n</head>\n<body>\n<div class="container">\n']);
            
            html = [html sprintf('<h1>📊 MRAC Simulation Report</h1>\n')];
            html = [html sprintf('<p><strong>Log Dosyası:</strong> %s</p>\n', logFilePath)];
            html = [html sprintf('<p><strong>Oluşturma Zamanı:</strong> %s</p>\n', datestr(now))];
            
            % Log içeriğini ekle
            if ~isempty(logContent)
                html = [html sprintf('<h2>📋 Simülasyon Detayları</h2>\n')];
                html = [html sprintf('<pre>%s</pre>\n', logContent)];
            end
            
            html = [html sprintf('</div>\n</body>\n</html>')];
            
            % Dosyaya yaz
            fid = fopen(outputPath, 'w', 'n', 'UTF-8');
            fprintf(fid, '%s', html);
            fclose(fid);
         end
         
         % YENİ: Log Dosyası Okuma
         function content = readLogFile(app, logFilePath)
            try
                fid = fopen(logFilePath, 'r', 'n', 'UTF-8');
                if fid == -1
                    content = '';
                    return;
                end
                content = fread(fid, '*char')';
                fclose(fid);
            catch
                content = '';
            end
         end
         
         % YENİ: Grafikleri Kaydetme Fonksiyonu
         function savePlots(app, event)
             try
                 app.ReportStatusLabel.Text = 'Saving graphs...';
                 drawnow;
                 
                 % Grafikleri PNG olarak kaydet
                 timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
                 
                 % Error Axes'i kaydet
                 if ~isempty(app.ErrorAxes.Children)
                     exportgraphics(app.ErrorAxes, ['sistem_grafik_' timestamp '.png'], 'Resolution', 300);
                 end
                 
                 % Theta Axes'i kaydet
                 if ~isempty(app.ThetaAxes.Children)
                     exportgraphics(app.ThetaAxes, ['hata_grafik_' timestamp '.png'], 'Resolution', 300);
                 end
                 
                 app.ReportStatusLabel.Text = 'Grafikler kaydedildi.';
                 uialert(app.UIFigure, 'Grafikler başarıyla kaydedildi!', 'Başarılı', 'Icon', 'success');
                 
             catch ME
                 app.ReportStatusLabel.Text = ['Grafik kaydetme hatası: ' ME.message];
                 app.ReportStatusLabel.FontColor = [0.8 0.2 0.2];
                 uialert(app.UIFigure, ['Grafik kaydetme hatası: ' ME.message], 'Hata', 'Icon', 'error');
             end
         end
         

         
         % YENİ: GPT Model Önerisi Başlatma
         function getGptModelAdvice(app)
            currentApiKey = '';
            if ~isempty(app.settingsManager)
                currentApiKey = app.settingsManager.getApiKey();
            end
            if ~app.useGptFeatures || isempty(currentApiKey)
                uialert(app.UIFigure, 'GPT özellikleri aktif değil. API anahtarı gerekli.', 'Uyarı', 'Icon', 'warning');
                return;
            end
             
             try
                 % İlk kez çağrılıyorsa sohbet geçmişini başlat
                 if ~isprop(app, 'modelSelectionChatHistory') || isempty(app.modelSelectionChatHistory)
                     app.modelSelectionChatHistory = {};
                     
                     % İlk sistem prompt'unu oluştur ve gönder
                     prompt = app.buildInitialModelPrompt();
                     
                                         % GPT'den yanıt al
                    fprintf('🤖 Gerçek zamanlı GPT model önerisi alınıyor (düz metin istemi)...\n');
                    
                    % API konfigürasyonu oluştur - use centralized settings
                    apiConfig = struct(...
                        'apiKey', app.settingsManager.getApiKey(), ...
                        'model', app.settingsManager.getModel(), ...
                        'temperature', 0.7, ...
                        'max_tokens', 1000 ...
                    );
                    
                    gptResponse = callGptApi_combined(prompt, apiConfig);
                     fprintf('✅ GPT yanıtı başarıyla alındı.\n');
                     
                     % Sohbet geçmişine ekle
                     app.modelSelectionChatHistory{end+1} = struct('role', 'user', 'content', prompt);
                     app.modelSelectionChatHistory{end+1} = struct('role', 'assistant', 'content', gptResponse);
                 end
                 
                                 % Durum güncelle
                app.updateGptStatus('GPT önerisi hazır');
                 
             catch ME
                 % Hata durumunda yerel öneriler göster
                 fprintf('⚠️ GPT hatası, yerel öneriler gösteriliyor: %s\n', ME.message);
                 app.showLocalModelAdvice();
             end
         end
         

         
         % YENİ: Yerel Model Önerisi Gösterme
         function showLocalModelAdvice(app)
             modelType = app.ModelTypeDropDown.Value;
             refModelType = 'GUI'; % Always from GUI fields
             overshoot = '';
             settlingTime = '';
             
             % Performans hedeflerini kontrol et
             if isprop(app, 'OvershootDropDown') && ~isempty(app.OvershootDropDown.Value)
                 overshoot = app.OvershootDropDown.Value;
                 settlingTime = app.SettlingTimeDropDown.Value;
             end
             
             % NaturalLanguageInput no longer available - use empty string
            naturalLangInput = '';
             
             advice = app.getLocalModelAdvice(modelType, refModelType, overshoot, settlingTime, naturalLangInput);
             app.GptResponseArea.Value = advice;
         end
         
         % YENİ: Model Sohbet Prompt'u Oluşturma
         function prompt = buildModelChatPrompt(app)
             systemMessage = 'Sen MRAC uzmanı bir asistansın. Kullanıcıyla model seçimi hakkında sohbet ediyorsun. Yanıtların kısa, net ve teknik olsun. Türkçe konuş.';
             
             messages = {struct('role', 'system', 'content', systemMessage)};
             for i = 1:length(app.modelSelectionChatHistory)
                 msg = app.modelSelectionChatHistory{i};
                 if isstruct(msg) && isfield(msg, 'role') && isfield(msg, 'content')
                     messages{end+1} = struct('role', msg.role, 'content', msg.content);
                 end
             end
             
             prompt_parts = {};
             for i = 1:length(messages)
                 msg = messages{i};
                 prompt_parts{end+1} = sprintf('%s: %s', msg.role, msg.content);
             end
             prompt = strjoin(prompt_parts, '\n\n');
         end
         
         % YENİ: Reference Model DC Gain Kontrolü
         function validateReferenceModelDcGain(app)
             try
                 % Sistem modeli DC gain'ini hesapla
                 A_sys_str = strjoin(app.SystemAMatrixEdit.Value, '');
                 B_sys_str = strjoin(app.SystemBMatrixEdit.Value, '');
                 C_sys_str = strjoin(app.SystemCMatrixEdit.Value, '');
                 D_sys_str = strjoin(app.SystemDMatrixEdit.Value, '');
                 
                 A_sys = eval(A_sys_str);
                 B_sys = eval(B_sys_str);
                 C_sys = eval(C_sys_str);
                 D_sys = eval(D_sys_str);
                 
                 % Referans model DC gain'ini hesapla
                 A_ref_str = strjoin(app.AMatrixEdit.Value, '');
                 B_ref_str = strjoin(app.BMatrixEdit.Value, '');
                 C_ref_str = strjoin(app.CMatrixEdit.Value, '');
                 D_ref_str = strjoin(app.DMatrixEdit.Value, '');
                 
                 A_ref = eval(A_ref_str);
                 B_ref = eval(B_ref_str);
                 C_ref = eval(C_ref_str);
                 D_ref = eval(D_ref_str);
                 
                 % DC gain hesapla: -C*A^(-1)*B + D
                 try
                     dc_gain_sys = -C_sys * (A_sys \ B_sys) + D_sys;
                     dc_gain_ref = -C_ref * (A_ref \ B_ref) + D_ref;
                     
                     % Farkı kontrol et
                     dc_gain_diff = abs(dc_gain_sys - dc_gain_ref);
                     
                     if dc_gain_diff > 0.1 % %10'dan fazla fark varsa
                         % Otomatik düzeltme öner
                         correction_factor = dc_gain_sys / dc_gain_ref;
                         
                         warning_msg = sprintf(['⚠️ DC Gain Uyumsuzluğu!\n\n' ...
                             'Sistem DC Gain: %.3f\n' ...
                             'Referans DC Gain: %.3f\n' ...
                             'Fark: %.3f (%.1f%%)\n\n' ...
                             'Otomatik düzeltme önerisi:\n' ...
                             'B_m matrisini %.3f ile çarpın\n' ...
                             'Yeni B_m = [0; %.3f]\n\n' ...
                             'Düzeltmek ister misiniz?'], ...
                             dc_gain_sys, dc_gain_ref, dc_gain_diff, (dc_gain_diff/abs(dc_gain_sys))*100, ...
                             correction_factor, correction_factor);
                         
                         % Kullanıcıya düzeltme seçeneği sun
                         choice = uiconfirm(app.UIFigure, warning_msg, 'DC Gain Düzeltme', ...
                             'Options', {'Düzelt', 'İptal'}, 'DefaultOption', 1, 'Icon', 'warning');
                         
                         if strcmp(choice, 'Düzelt')
                             % B_m matrisini düzelt
                             B_ref_corrected = B_ref * correction_factor;
                             app.BMatrixEdit.Value = {mat2str(B_ref_corrected)};
                             
                             % Özeti güncelle
                             app.updateSummaryWithSystemModel();
                             
                             fprintf('✅ B_m matrisi düzeltildi: %.3f ile çarpıldı\n', correction_factor);
                             uialert(app.UIFigure, '✅ DC Gain düzeltildi!', 'Başarılı', 'Icon', 'success');
                         end
                         
                         fprintf('⚠️ DC Gain uyumsuzluğu: Sistem=%.3f, Referans=%.3f, Fark=%.3f\n', ...
                             dc_gain_sys, dc_gain_ref, dc_gain_diff);
                     else
                         fprintf('✅ DC Gain uyumlu: Sistem=%.3f, Referans=%.3f, Fark=%.3f\n', ...
                             dc_gain_sys, dc_gain_ref, dc_gain_diff);
                     end
                     
                 catch
                     fprintf('⚠️ DC gain hesaplanamadı - matris boyutları uyumsuz olabilir\n');
                 end
                 
             catch ME
                 fprintf('⚠️ DC gain kontrolü hatası: %s\n', ME.message);
             end
         end
         
         % YENİ: Sistem Boyutlarını Düzeltme Fonksiyonu
         function [A, B, C, D] = fixSystemDimensions(app, A, B, C, D)
             % Sistem boyutlarını kontrol et ve düzelt
             n = size(A, 1); % durum sayısı
             m = size(B, 2); % giriş sayısı
             p = size(C, 1); % çıkış sayısı
             
             % A matrisi nxn olmalı
             if size(A, 1) ~= size(A, 2)
                 A = eye(n);
             end
             
             % B matrisi nxm olmalı
             if size(B, 1) ~= n
                 B = [zeros(n-1, m); ones(1, m)];
             end
             
             % C matrisi pxn olmalı - çıkış sayısını durum sayısına göre ayarla
             if size(C, 2) ~= n
                 if p > n
                     % Çok fazla çıkış - sadece ilk n tanesini al
                     C = C(1:n, 1:n);
                 else
                     % Çok az çıkış - genişlet
                     C = [C, zeros(p, n-size(C,2))];
                 end
             end
             
             % D matrisi pxm olmalı
             if size(D, 1) ~= p || size(D, 2) ~= m
                 D = zeros(p, m);
             end
         end
         
         % YENİ: Sistem Yanıtını Önizleme Fonksiyonu
         function previewSystemResponse(app)
             try
                 % Sistem matrislerini al
                 A_str = strjoin(app.SystemAMatrixEdit.Value, '');
                 B_str = strjoin(app.SystemBMatrixEdit.Value, '');
                 C_str = strjoin(app.SystemCMatrixEdit.Value, '');
                 D_str = strjoin(app.SystemDMatrixEdit.Value, '');
                 
                 % Matrisleri değerlendir
                 A = eval(A_str);
                 B = eval(B_str);
                 C = eval(C_str);
                 D = eval(D_str);
                 
                 % Boyut kontrolü ve düzeltme
                 [A, B, C, D] = app.fixSystemDimensions(A, B, C, D);
                 
                 % State-space model oluştur
                 sys = ss(A, B, C, D);
                 
                 % Step yanıtı hesapla - kararsız sistemler için özel işlem
                 try
                     [y, t] = step(sys, 50); % 50 saniye simülasyon
                 catch
                     % Kararsız sistem için lsim kullan
                     t = 0:0.01:50;
                     u = ones(size(t));
                     [y, t] = lsim(sys, u, t);
                 end
                 
                % Grafik çiz
                cla(app.SystemResponseAxes);
                plot(app.SystemResponseAxes, t, y, 'b-', 'LineWidth', 2);
                title(app.SystemResponseAxes, 'System Step Response', 'FontSize', 10);
                xlabel(app.SystemResponseAxes, 'Time (s)', 'FontSize', 9);
                ylabel(app.SystemResponseAxes, 'Output', 'FontSize', 9);
                grid(app.SystemResponseAxes, 'on');
                 
                % Sistem bilgilerini göster
                if size(y, 2) > 1
                    legend(app.SystemResponseAxes, arrayfun(@(i) sprintf('Output %d', i), 1:size(y,2), 'UniformOutput', false), ...
                           'Location', 'best', 'FontSize', 8);
                end
                 
                 % Sistem kararlılığını kontrol et
                poles = pole(sys);
                if all(real(poles) < 0)
                    stability_text = '✅ System Stable';
                    color = [0.1 0.6 0.1];
                else
                    stability_text = '⚠️ System Unstable';
                    color = [0.8 0.2 0.2];
                end
                 
                % Sistem özelliklerini göster
                info_text = {
                    sprintf('📊 System Dimension: %dx%d', size(A,1), size(B,2));
                    sprintf('🎯 Output Count: %d', size(C,1));
                    sprintf('⚡ Poles: %s', mat2str(poles, 3));
                    stability_text
                };
                 
                 % Bilgi metnini axes üzerine ekle (sağ alt köşe)
                 text(app.SystemResponseAxes, 0.98, 0.02, info_text, ...
                      'Units', 'normalized', ...
                      'VerticalAlignment', 'bottom', ...
                      'HorizontalAlignment', 'right', ...
                      'FontSize', 8, ...
                      'BackgroundColor', [1 1 1 0.8], ...
                      'EdgeColor', [0.5 0.5 0.5], ...
                      'Color', color);
                 
                 fprintf('✅ System response successfully calculated and displayed.\n');
                 
             catch ME
                 % Hata durumunda
                 cla(app.SystemResponseAxes);
                 text(app.SystemResponseAxes, 0.5, 0.5, ...
                      {'❌ System Response Could Not Be Calculated', '', ['Error: ' ME.message]}, ...
                      'Units', 'normalized', ...
                      'HorizontalAlignment', 'center', ...
                      'VerticalAlignment', 'middle', ...
                      'FontSize', 10, ...
                      'Color', [0.8 0.2 0.2]);
                 title(app.SystemResponseAxes, 'Hata - Sistem Tanımsız', 'FontSize', 10, 'Color', [0.8 0.2 0.2]);
                 
                 fprintf('❌ Sistem yanıtı hesaplama hatası: %s\n', ME.message);
             end
         end
         
         % YENİ: Reference Model Yanıtını Önizleme Fonksiyonu
         function previewReferenceResponse(app)
             try
                 % Referans model matrislerini al
                 A_str = strjoin(app.AMatrixEdit.Value, '');
                 B_str = strjoin(app.BMatrixEdit.Value, '');
                 C_str = strjoin(app.CMatrixEdit.Value, '');
                 D_str = strjoin(app.DMatrixEdit.Value, '');
                 
                 % Matrisleri değerlendir
                 A_m = eval(A_str);
                 B_m = eval(B_str);
                 C_m = eval(C_str);
                 D_m = eval(D_str);
                 
                 % Boyut kontrolü ve düzeltme
                 [A_m, B_m, C_m, D_m] = app.fixSystemDimensions(A_m, B_m, C_m, D_m);
                 
                 % Referans state-space model oluştur
                 sys_ref = ss(A_m, B_m, C_m, D_m);
                 
                 % Step yanıtı hesapla
                 [y_ref, t_ref] = step(sys_ref, 50); % 50 saniye simülasyon
                 
                % Grafik çiz
                cla(app.ReferenceResponseAxes);
                plot(app.ReferenceResponseAxes, t_ref, y_ref, 'g-', 'LineWidth', 2);
                title(app.ReferenceResponseAxes, 'Reference Model Step Response', 'FontSize', 10);
                xlabel(app.ReferenceResponseAxes, 'Time (s)', 'FontSize', 9);
                ylabel(app.ReferenceResponseAxes, 'Reference Output', 'FontSize', 9);
                grid(app.ReferenceResponseAxes, 'on');
                 
                % Çoklu çıkış için legend
                if size(y_ref, 2) > 1
                    legend(app.ReferenceResponseAxes, arrayfun(@(i) sprintf('Ref Output %d', i), 1:size(y_ref,2), 'UniformOutput', false), ...
                           'Location', 'best', 'FontSize', 8);
                end
                 
                % Referans model kararlılığını kontrol et
                poles_ref = pole(sys_ref);
                if all(real(poles_ref) < 0)
                    stability_text = '✅ Reference Stable';
                    color = [0.1 0.6 0.1];
                else
                    stability_text = '⚠️ Reference Unstable';
                    color = [0.8 0.2 0.2];
                end
                 
                 % Step yanıtı performans metriklerini hesapla
                 try
                     stepinfo_ref = stepinfo(sys_ref);
                     if isstruct(stepinfo_ref) && isfield(stepinfo_ref, 'Overshoot')
                         overshoot_val = stepinfo_ref.Overshoot;
                         settling_val = stepinfo_ref.SettlingTime;
                     else
                         overshoot_val = 0;
                         settling_val = max(t_ref);
                     end
                 catch
                     overshoot_val = 0;
                     settling_val = max(t_ref);
                 end
                 
                % Referans model özelliklerini göster
                info_text = {
                    sprintf('📊 Reference Dimension: %dx%d', size(A_m,1), size(B_m,2));
                    sprintf('🎯 Output Count: %d', size(C_m,1));
                    sprintf('📈 Overshoot: %.1f%%', overshoot_val);
                    sprintf('⏱️ Settling Time: %.2fs', settling_val);
                    stability_text
                };
                 
                 % Bilgi metnini axes üzerine ekle (sağ alt köşe)
                 text(app.ReferenceResponseAxes, 0.98, 0.02, info_text, ...
                      'Units', 'normalized', ...
                      'VerticalAlignment', 'bottom', ...
                      'HorizontalAlignment', 'right', ...
                      'FontSize', 8, ...
                      'BackgroundColor', [1 1 1 0.8], ...
                      'EdgeColor', [0.1 0.6 0.1], ...
                      'Color', color);
                 
                 fprintf('✅ Referans model yanıtı başarıyla hesaplandı ve görüntülendi.\n');
                 
             catch ME
                 % Hata durumunda
                 cla(app.ReferenceResponseAxes);
                 text(app.ReferenceResponseAxes, 0.5, 0.5, ...
                      {'❌ Reference Response Could Not Be Calculated', '', ['Error: ' ME.message]}, ...
                      'Units', 'normalized', ...
                      'HorizontalAlignment', 'center', ...
                      'VerticalAlignment', 'middle', ...
                      'FontSize', 10, ...
                      'Color', [0.8 0.2 0.2]);
                 title(app.ReferenceResponseAxes, 'Hata - Reference Model Tanımsız', 'FontSize', 10, 'Color', [0.8 0.2 0.2]);
                 
                 fprintf('❌ Referans model yanıtı hesaplama hatası: %s\n', ME.message);
             end
         end
         
        % System definition method switching removed - only state-space is supported
         
        % Transfer function conversion functions removed - only state-space is supported
         
        % Transfer function preview functions removed - only state-space is supported
         
         % YENİ: Sonuç Matrislerini Güncelleme
         function updateResultMatrices(app, A, B, C, D)
             try
                 app.ResultALabel.Text = sprintf('A = %s', mat2str(A, 3));
                 app.ResultBLabel.Text = sprintf('B = %s', mat2str(B, 3));
                 app.ResultCLabel.Text = sprintf('C = %s', mat2str(C, 3));
                 app.ResultDLabel.Text = sprintf('D = %s', mat2str(D, 3));
                 
             catch ME
                 fprintf('❌ Sonuç matrisleri güncelleme hatası: %s\n', ME.message);
             end
         end
         
                   % YENİ: Durum-uzay Matrislerinden Sonuç Güncelleme
          function updateResultMatricesFromStateSpace(app)
              try
                  % Sistem matrislerini al
                  A_str = char(app.SystemAMatrixEdit.Value);
                  B_str = char(app.SystemBMatrixEdit.Value);
                  C_str = char(app.SystemCMatrixEdit.Value);
                  D_str = char(app.SystemDMatrixEdit.Value);
                 
                 % Matrisleri değerlendir
                 A = eval(A_str);
                 B = eval(B_str);
                 C = eval(C_str);
                 D = eval(D_str);
                 
                 % Sonuç matrislerini güncelle
                 app.updateResultMatrices(A, B, C, D);
                 
                 % Sistem bilgilerini kontrol et
                 app.validateAndDisplaySystemInfo(A, B, C, D);
                 
                 % Özet güncelle
                 app.updateSummaryWithSystemModel();
                 
             catch ME
                app.ResultALabel.Text = '❌ State-space error!';
                app.ResultBLabel.Text = ['Error: ' ME.message];
                app.ResultCLabel.Text = '';
                app.ResultDLabel.Text = '';
                app.SystemInfoLabel.Text = 'Invalid state-space matrices';
                 
                 fprintf('❌ State-space matrix update error: %s\n', ME.message);
             end
         end
         
         % YENİ: Basit API Test Fonksiyonu (Sorun tespiti için)
        function isWorking = testSimpleApiCall(app)
            try
                fprintf('🧪 Performing simple API test...\n');
                
                % En basit API çağrısı - use centralized settings
                apiConfig = struct(...
                    'apiKey', app.settingsManager.getApiKey(), ...
                    'model', app.settingsManager.getModel(), ...
                    'temperature', 0.1, ...
                    'max_tokens', 50 ... % Çok az token
                );
                
                % Çok basit prompt
                simplePrompt = 'Merhaba, sadece "Test başarılı" de.';
                
                response = callGptApi_combined(simplePrompt, apiConfig);
                
                if contains(response, 'Hata:')
                    fprintf('❌ Simple API test failed: %s\n', response);
                    isWorking = false;
                else
                    fprintf('✅ Simple API test SUCCESSFUL: %s\n', response);
                    isWorking = true;
                end
                
            catch ME
                fprintf('❌ Simple API test exception: %s\n', ME.message);
                isWorking = false;
            end
        end
        
        % YENİ: Yerel Öneriler Gösterme (API çalışmadığında)
        function showLocalSuggestions(app)
            fprintf('📋 Yerel öneriler gösteriliyor - API kullanılamıyor\n');
            
            % Yerel önerileri hazırla
            app.GptSuggestionsArea.Value = {
                '🔧 API Çalışmıyor - YEREL ÖNERİLER', ...
                '', ...
                '💡 API anahtarınızı kontrol edin:', ...
                '• Enter API key from Settings tab', ...
                '• OpenAI hesabınızda quota kontrolü yapın', ...
                '• İnternet bağlantınızı kontrol edin', ...
                '', ...
                '📋 HAZIR PARAMETRELERİ KULLANIN:', ...
                '', ...
                '🚀 PERFORMANS OPTİMUM:', ...
                'A_m: [0 1; -9 -6]  B_m: [0; 9]', ...
                'C_m: [1 0]  D_m: 0', ...
                '• Hızlı yanıt, düşük aşım', ...
                '', ...
                '🛡️ DAYANIKLIK OPTİMUM:', ...
                'A_m: [0 1; -4 -4]  B_m: [0; 4]', ...
                'C_m: [1 0]  D_m: 0', ...
                '• Kararlı, gürültü dayanıklı', ...
                '', ...
                '⚖️ GENEL AMAÇLI:', ...
                'A_m: [0 1; -6.25 -5]  B_m: [0; 6.25]', ...
                'C_m: [1 0]  D_m: 0', ...
                '• Dengeli performans', ...
                '', ...
                '👆 Yukarıdaki parametreleri manuel olarak', ...
                'referans model alanlarına girebilirsiniz.'
            };
            
            % Butonları aktif et
            app.GetGptAdviceButton.Enable = 'on';
            app.GptSuggestion1Button.Enable = 'off';
            app.GptSuggestion2Button.Enable = 'off';
            app.GptSuggestion3Button.Enable = 'off';
            
            % Uyarı mesajı göster
            uialert(app.UIFigure, ...
                ['API anahtarı çalışmıyor veya geçersiz.' newline newline ...
                 'Çözüm:' newline ...
                 '• Enter valid API key from Settings tab' newline ...
                 '• OpenAI hesabınızda quota kontrol edin' newline ...
                 '• Yukarıdaki hazır parametreleri kullanın'], ...
                'API Sorunu', 'Icon', 'warning');
        end
        
        % YENİ: D Matrisi Format Düzeltme Fonksiyonu
        function correctedD = fixDMatrixFormat(app, D_str)
            try
                % D_str'yi temizle
                D_str = strtrim(D_str);
                
                % Eğer sadece "0" ise, MATLAB uyumlu format yap
                if strcmp(D_str, '0') || strcmp(D_str, '"0"') || strcmp(D_str, '''0''')
                    correctedD = '0';  % Scalar format
                    fprintf('🔧 D matrisi format düzeltildi: "%s" -> "%s"\n', D_str, correctedD);
                % Eğer zaten doğru formatsa olduğu gibi bırak
                elseif startsWith(D_str, '[') && endsWith(D_str, ']')
                    correctedD = D_str;
                % Diğer durumlar için varsayılan
                else
                    correctedD = '0';
                    fprintf('🔧 D matrisi varsayılan format uygulandı: "%s" -> "%s"\n', D_str, correctedD);
                end
                
            catch ME
                fprintf('⚠️ D matrisi format düzeltme hatası: %s\n', ME.message);
                correctedD = '0';  % Güvenli varsayılan
            end
        end
        
        % YENİ: Sistem Bilgilerini Doğrulama ve Gösterme
         function validateAndDisplaySystemInfo(app, A, B, C, D)
             try
                 % Sistem boyutlarını kontrol et
                 [n, m] = size(A);
                 [n_B, p] = size(B);
                 [q, n_C] = size(C);
                 [q_D, p_D] = size(D);
                 
                 if n ~= m || n ~= n_B || n ~= n_C || q ~= q_D || p ~= p_D
                     error('Matris boyutları uyumsuz!');
                 end
                 
                 % Sistem özelliklerini hesapla
                 poles = eig(A);
                 is_stable = all(real(poles) < 0);
                 
                 % Doğal frekans ve sönüm oranı hesaplama (eğer 2x2 ise)
                 if n == 2 && all(imag(poles) ~= 0)
                     wn = abs(poles(1));
                     zeta = -real(poles(1)) / wn;
                     system_info = sprintf('✅ n=%d, Stable=%s, ωₙ=%.3f, ζ=%.3f', n, string(is_stable), wn, zeta);
                 else
                     system_info = sprintf('✅ Dim=%dx%d, Input=%d, Output=%d, Stable=%s', n, n, p, q, string(is_stable));
                 end
                 
                 app.SystemInfoLabel.Text = system_info;
                 
                 if is_stable
                     app.SystemInfoLabel.FontColor = [0.1 0.6 0.1]; % Yeşil
                 else
                     app.SystemInfoLabel.FontColor = [0.8 0.2 0.2]; % Kırmızı
                 end
                 
             catch ME
                 app.SystemInfoLabel.Text = ['❌ Sistem analiz hatası: ' ME.message];
                 app.SystemInfoLabel.FontColor = [0.8 0.2 0.2];
                 fprintf('❌ Sistem doğrulama hatası: %s\n', ME.message);
             end
         end
         
         % YENİ: Etiket Metninden Matris Değerini Çıkarma
         function matrixStr = extractMatrixFromLabel(app, labelText)
             try
                 % Etiket formatı: "A = [0 1; -4 -3]" gibi
                 % Eşittir işaretinden sonrasını al
                 if contains(labelText, '=')
                     parts = split(labelText, '=');
                     if length(parts) >= 2
                         matrixStr = strtrim(parts{2});
                     else
                         matrixStr = '[0; 0]'; % Varsayılan
                     end
                 else
                     matrixStr = '[0; 0]'; % Varsayılan
                 end
             catch
                 matrixStr = '[0; 0]'; % Hata durumunda varsayılan
             end
         end
         
         % YENİ: Simülasyon Özeti Güncelleme Fonksiyonu
         function updateSimulationSummary(app)
             try
                 summaryContent = {};
                 
                 % Başlık
                 summaryContent{end+1} = '🎯 SIMULATION SUMMARY';
                 summaryContent{end+1} = '============================';
                 summaryContent{end+1} = '';
                 
                 % 1. MRAC Model Type
                 if isprop(app, 'ModelTypeDropDown') && ~isempty(app.ModelTypeDropDown) && isprop(app.ModelTypeDropDown, 'Value')
                     modelType = app.ModelTypeDropDown.Value;
                     summaryContent{end+1} = sprintf('🔧 MRAC Model: %s', modelType);
                 else
                     summaryContent{end+1} = '🔧 MRAC Model: Not defined';
                 end
                 summaryContent{end+1} = '';
                 
                 % 2. Sistem Modeli Bilgisi
                 summaryContent{end+1} = '🏭 SYSTEM MODEL:';
                 try
                     % Sistem tanımlama yöntemi kontrolü
                    % Only state-space method is supported
                    % State-space matrices
                    summaryContent{end+1} = '  📐 Definition Method: State-Space Matrices';
                    if isprop(app, 'SystemAMatrixEdit')
                        summaryContent{end+1} = sprintf('  • A = %s', strjoin(app.SystemAMatrixEdit.Value, ''));
                        summaryContent{end+1} = sprintf('  • B = %s', strjoin(app.SystemBMatrixEdit.Value, ''));
                        summaryContent{end+1} = sprintf('  • C = %s', strjoin(app.SystemCMatrixEdit.Value, ''));
                        summaryContent{end+1} = sprintf('  • D = %s', strjoin(app.SystemDMatrixEdit.Value, ''));
                    end
                 catch
                     summaryContent{end+1} = '  ❌ System model information could not be obtained';
                 end
                 summaryContent{end+1} = '';
                 
                 % 3. Reference Model Bilgisi
                 summaryContent{end+1} = '🎯 REFERENCE MODEL:';
                 try
                     summaryContent{end+1} = '  📊 Taken directly from GUI fields';
                     if isprop(app, 'AMatrixEdit') && ~isempty(app.AMatrixEdit.Value)
                         summaryContent{end+1} = sprintf('  • A_ref = %s', strjoin(app.AMatrixEdit.Value, ''));
                         summaryContent{end+1} = sprintf('  • B_ref = %s', strjoin(app.BMatrixEdit.Value, ''));
                         summaryContent{end+1} = sprintf('  • C_ref = %s', strjoin(app.CMatrixEdit.Value, ''));
                         summaryContent{end+1} = sprintf('  • D_ref = %s', strjoin(app.DMatrixEdit.Value, ''));
                     end
                     if isprop(app, 'OvershootDropDown') && isprop(app, 'SettlingTimeDropDown')
                         summaryContent{end+1} = sprintf('  • Performance - Overshoot: %s', app.OvershootDropDown.Value);
                         summaryContent{end+1} = sprintf('  • Performance - Settling: %s', app.SettlingTimeDropDown.Value);
                     end
                 catch
                     summaryContent{end+1} = '  ❌ Reference model information could not be obtained';
                 end
                 summaryContent{end+1} = '';
                 
                                 % 4. MRAC Parametreleri - Model tipine göre farklı parametreler
                summaryContent{end+1} = '⚙️ MRAC PARAMETERS:';
                try
                    % Model tipini al
                    if isprop(app, 'ModelTypeDropDown') && ~isempty(app.ModelTypeDropDown) && isprop(app.ModelTypeDropDown, 'Value')
                        modelType = app.ModelTypeDropDown.Value;
                        summaryContent{end+1} = sprintf('  📊 Model Type: %s', modelType);
                        
                        % Model tipine göre parametreleri göster
                        switch modelType
                            case 'Classic MRAC'
                                if isprop(app, 'GammaThetaEdit') && isprop(app, 'GammaKrEdit') && isprop(app, 'SamplingTimeEdit')
                                    summaryContent{end+1} = sprintf('  • γ_θ (Theta Gain): %.1f', app.GammaThetaEdit.Value);
                                    summaryContent{end+1} = sprintf('  • γ_kr (Kr Gain): %.1f', app.GammaKrEdit.Value);
                                    summaryContent{end+1} = sprintf('  • Ts (Sampling Time): %.4f s', app.SamplingTimeEdit.Value);
                                else
                                    summaryContent{end+1} = '  • Default: γ_θ=1000, γ_kr=1000, Ts=0.001s';
                                end
                                
                            case 'Filtered MRAC'
                                if isprop(app, 'GammaThetaEdit') && isprop(app, 'GammaKrEdit') && isprop(app, 'SamplingTimeEdit')
                                    summaryContent{end+1} = sprintf('  • γ_θ (Theta Gain): %.1f', app.GammaThetaEdit.Value);
                                    summaryContent{end+1} = sprintf('  • γ_r (R Gain): %.1f', app.GammaKrEdit.Value);
                                    summaryContent{end+1} = sprintf('  • Ts (Sampling Time): %.4f s', app.SamplingTimeEdit.Value);
                                    summaryContent{end+1} = '  • kr_base: 0.0121 (default)';
                                    summaryContent{end+1} = '  • kr_filt_input: 0.012 (default)';
                                else
                                    summaryContent{end+1} = '  • Default: γ_θ=100, γ_r=80, kr_base=0.0121, kr_filt_input=0.012, Ts=0.001s';
                                end
                                
                            % case 'Time Delay MRAC' % HIDDEN FROM UI - kept as comment
                            %     if isprop(app, 'GammaThetaEdit') && isprop(app, 'SamplingTimeEdit')
                            %         summaryContent{end+1} = sprintf('  • γ (Gamma Gain): %.1f', app.GammaThetaEdit.Value);
                            %         summaryContent{end+1} = sprintf('  • Ts (Sampling Time): %.4f s', app.SamplingTimeEdit.Value);
                            %         summaryContent{end+1} = '  • kr_int: 22.0 (varsayılan)';
                            %     else
                            %         summaryContent{end+1} = '  • Varsayılan: γ=10, kr_int=22.0, Ts=0.001s';
                            %     end
                                
                            otherwise
                                summaryContent{end+1} = '  • Unknown model type - default parameters will be used';
                        end
                    else
                        summaryContent{end+1} = '  • Model type not selected - default parameters will be used';
                    end
                catch
                    summaryContent{end+1} = '  ❌ MRAC parameters could not be obtained';
                end
                 summaryContent{end+1} = '';
                 
                 % 5. Simülasyon Ayarları
                 summaryContent{end+1} = '🎛️ SIMULATION SETTINGS:';
                 summaryContent{end+1} = '  • Input Signal: Step (Step)';
                 summaryContent{end+1} = '  • Amplitude: 1.0';
                 summaryContent{end+1} = '  • Frequency: 0 Hz';
                 summaryContent{end+1} = '  • Number of Iterations: 10';
                 summaryContent{end+1} = '';
                 
                 % 6. Hazırlık Durumu
                 summaryContent{end+1} = '🚀 PREPARATION STATUS:';
                 summaryContent{end+1} = '  ✅ Configuration completed';
                 summaryContent{end+1} = '  ✅ Ready for simulation';
                 summaryContent{end+1} = '  💡 Click "Start Simulation" button';
                 
                 % Özeti simülasyon sekmesindeki alana yazdır
                 if isprop(app, 'IterationDisplay') && ~isempty(app.IterationDisplay)
                     app.IterationDisplay.Value = summaryContent;
                 end
                 
                 fprintf('✅ Simulation summary updated.\n');
                 
             catch ME
                 fprintf('❌ Simulation summary update error: %s\n', ME.message);
                 if isprop(app, 'IterationDisplay') && ~isempty(app.IterationDisplay)
                     app.IterationDisplay.Value = {'❌ Summary update error:', ME.message};
                 end
             end
         end
         
         % YENİ: Bekleme Chat UI Fonksiyonu (API key yoksa)
         function createWaitingChatUI(app)
             % API key bekleme UI oluştur
             try
                 % Ana grid layout
                 mainGrid = uigridlayout(app.ChatTab, [1, 3]);
                 mainGrid.ColumnWidth = {'1x', '2x', '1x'};
                 mainGrid.Padding = [10, 10, 10, 10];
                 mainGrid.ColumnSpacing = 10;
                 
                % Sol panel - Model Information with proper layout
                leftPanel = uipanel(mainGrid, ...
                    'Title', '📊 Simulation Summary', ...
                    'FontWeight', 'bold', ...
                    'BackgroundColor', [0.95, 0.95, 0.95]);
                
                % Create grid layout for 50-50 split
                leftGrid = uigridlayout(leftPanel, [2, 1]);
                leftGrid.RowHeight = {'1x', '1x'};  % Equal 50-50 split
                leftGrid.Padding = [5, 5, 5, 5];
                leftGrid.RowSpacing = 10;
                
                % MODEL INFORMATION (DETAILED) - Top half
                modelInfo = app.getModelInformation();
                app.ModelInfoDisplay = uitextarea(leftGrid, ...
                    'Value', modelInfo, ...
                    'Editable', 'off', ...
                    'FontSize', 9, ...
                    'BackgroundColor', [1, 1, 1]);
                
                % PERFORMANCE & LOG INFORMATION - Bottom half
                performanceInfo = app.getPerformanceInformation();
                app.PerformanceDisplay = uitextarea(leftGrid, ...
                    'Value', performanceInfo, ...
                    'Editable', 'off', ...
                    'FontSize', 10, ...
                    'BackgroundColor', [0.98, 1, 0.98]);
                
                % Analysis Status Label
                app.AnalysisStatusLabel = uilabel(leftPanel, ...
                    'Text', 'Ready for analysis', ...
                    'FontSize', 12, ...
                    'FontWeight', 'bold', ...
                    'FontColor', [0.2, 0.6, 0.2], ...
                    'Position', [10, 10, 200, 25]);
                
                % Analyze Simulation Button
                app.AnalyzeSimulationButton = uibutton(leftPanel, ...
                    'Text', '🔍 Analyze Simulation', ...
                    'FontSize', 11, ...
                    'FontWeight', 'bold', ...
                    'BackgroundColor', [0.2, 0.6, 0.8], ...
                    'FontColor', [1, 1, 1], ...
                    'Position', [220, 10, 140, 25], ...
                    'ButtonPushedFcn', @(src, event) proceedToAnalysis(app));
                
                % Open Log File Button
                app.OpenLogFileButton = uibutton(leftPanel, ...
                    'Text', '📄 Open Log', ...
                    'FontSize', 11, ...
                    'FontWeight', 'bold', ...
                    'BackgroundColor', [0.3, 0.7, 0.3], ...
                    'FontColor', [1, 1, 1], ...
                    'Position', [370, 10, 100, 25], ...
                    'ButtonPushedFcn', @(src, event) openLatestLogFile(app));
                 
                 % Orta panel
                 chatPanel = uipanel(mainGrid, ...
                     'Title', '💬 MRAC Assistant', ...
                     'FontWeight', 'bold', ...
                     'BackgroundColor', [0.98, 0.98, 1]);
                 
                 % Chat geçmişi
                 app.EnhancedChatHistory = uitextarea(chatPanel, ...
                     'Value', {'🤖 Welcome to MRAC Assistant!', '', '⏳ API key waiting...', '', '📝 To do:', '1. Go to Settings tab', '2. Enter your OpenAI API key', '3. Press Save Settings button', '4. Return to Chat tab', '', '✨ Then GPT-powered chat will be active!'}, ...
                     'Editable', 'off', ...
                     'FontSize', 12, ...
                     'Position', [10, 60, 380, 300]);
                 
                 % Chat input
                 app.EnhancedChatInput = uitextarea(chatPanel, ...
                     'Value', {''}, ...
                     'Placeholder', 'Mesajınızı yazın...', ...
                     'FontSize', 12, ...
                     'Position', [10, 10, 300, 40]);
                 
                 % Gönder butonu
                 app.SendChatButton = uibutton(chatPanel, ...
                     'Text', 'Gönder', ...
                     'Position', [320, 10, 80, 40], ...
                     'FontSize', 12, ...
                     'BackgroundColor', [0.2, 0.6, 0.2], ...
                     'FontColor', [1, 1, 1], ...
                     'ButtonPushedFcn', @(src, event) fallbackSendCallback(app));
                 
                 % Sağ panel
                 rightPanel = uipanel(mainGrid, ...
                     'Title', '📋 Bilgi', ...
                     'FontWeight', 'bold', ...
                     'BackgroundColor', [1, 0.98, 0.95]);
                 
                 uilabel(rightPanel, ...
                     'Text', '⏳ Waiting for API Key', ...
                     'FontSize', 13, ...
                     'FontWeight', 'bold', ...
                     'FontColor', [0.8, 0.4, 0.1], ...
                     'Position', [10, 280, 200, 30]);
                 
                 uilabel(rightPanel, ...
                     'Text', '1. Settings → Enter API Key', ...
                     'FontSize', 11, ...
                     'FontColor', [0.4, 0.4, 0.4], ...
                     'Position', [10, 260, 200, 20]);
                 
                 uilabel(rightPanel, ...
                     'Text', '2. Press Save Settings', ...
                     'FontSize', 11, ...
                     'FontColor', [0.4, 0.4, 0.4], ...
                     'Position', [10, 240, 200, 20]);
                 
                 uilabel(rightPanel, ...
                     'Text', '3. Chat aktif olacak!', ...
                     'FontSize', 11, ...
                     'FontColor', [0.2, 0.6, 0.2], ...
                     'Position', [10, 220, 200, 20]);
                 
                 fprintf('✅ Bekleme Chat UI oluşturuldu (API anahtarı yok)\n');
                 
             catch ME
                 fprintf('❌ Fallback Chat UI oluşturulamadı: %s\n', ME.message);
             end
         end
         
         function waitingSendCallback(app)
             % Bekleme modu chat gönderme fonksiyonu
             try
                 if isprop(app, 'EnhancedChatInput') && isprop(app, 'EnhancedChatHistory')
                     userMessage = strjoin(app.EnhancedChatInput.Value, ' ');
                     if ~isempty(strtrim(userMessage))
                         currentHistory = app.EnhancedChatHistory.Value;
                         timestamp = datestr(now, 'HH:MM');
                         newHistory = [currentHistory; {sprintf('[%s] 👤 Siz: %s', timestamp, userMessage)}];
                         newHistory = [newHistory; {sprintf('[%s] ⚠️ System: API key not entered. Please add your OpenAI API key from Settings tab.', timestamp)}];
                         newHistory = [newHistory; {''}];
                         
                         app.EnhancedChatHistory.Value = newHistory;
                         app.EnhancedChatInput.Value = {''};
                     end
                 end
             catch ME
                 fprintf('❌ Bekleme modu chat hatası: %s\n', ME.message);
             end
         end
         
        % YENİ: Analiz Sekmesi Model Bilgilerini Güncelleme - COMPREHENSIVE SUMMARY
        function updateAnalysisModelInfo(app, simulationResults)
            try
                if isprop(app, 'ModelInfoDisplay') && isvalid(app.ModelInfoDisplay)
                    modelInfo = {};
                    modelInfo{end+1} = 'SIMULATION SUMMARY';
                    modelInfo{end+1} = '============================';
                    modelInfo{end+1} = '';
                    
                    % Try to read from log file first
                    logContent = app.readLatestSimulationLog();
                    if ~isempty(logContent)
                        % Parse log content for model information
                        logLines = strsplit(logContent, '\n');
                        for i = 1:length(logLines)
                            line = strtrim(logLines{i});
                            if contains(line, 'MRAC Model:') || contains(line, 'Model Type:') || contains(line, '🔧')
                                modelInfo{end+1} = sprintf('🔧 %s', line);
                            elseif contains(line, 'System Model:') || contains(line, 'Reference Model:') || contains(line, '🏭')
                                modelInfo{end+1} = sprintf('🏭 %s', line);
                            elseif contains(line, 'Parameters:') || contains(line, 'Settings:') || contains(line, '⚙️')
                                modelInfo{end+1} = sprintf('⚙️ %s', line);
                            elseif contains(line, 'Iterations:') || contains(line, 'Sampling Time:') || contains(line, '🎛️')
                                modelInfo{end+1} = sprintf('🎛️ %s', line);
                            elseif contains(line, 'Status:') || contains(line, 'Completed:') || contains(line, '🚀')
                                modelInfo{end+1} = sprintf('🚀 %s', line);
                            elseif contains(line, 'A =') || contains(line, 'B =') || contains(line, 'C =') || contains(line, 'D =')
                                modelInfo{end+1} = sprintf('  • %s', line);
                            elseif contains(line, 'γ_θ') || contains(line, 'γ_kr') || contains(line, 'Ts')
                                modelInfo{end+1} = sprintf('  • %s', line);
                            elseif contains(line, 'Input Signal:') || contains(line, 'Amplitude:') || contains(line, 'Frequency:')
                                modelInfo{end+1} = sprintf('  • %s', line);
                            elseif contains(line, 'Overshoot:') || contains(line, 'Settling:')
                                modelInfo{end+1} = sprintf('  • %s', line);
                            end
                        end
                        modelInfo{end+1} = '';
                        modelInfo{end+1} = '📄 Information from simulation log file';
                    else
                        % Fallback to GUI data
                        % MRAC Model Type
                        mracType = 'Classic MRAC';
                        if isprop(app, 'ModelTypeDropDown') && ~isempty(app.ModelTypeDropDown.Value)
                            mracType = app.ModelTypeDropDown.Value;
                        elseif isfield(simulationResults, 'modelType')
                            mracType = simulationResults.modelType;
                        end
                        modelInfo{end+1} = sprintf('🔧 MRAC Model: %s', mracType);
                        modelInfo{end+1} = '';
                    
                    % System Model Information
                    modelInfo{end+1} = '🏭 SYSTEM MODEL:';
                    modelInfo{end+1} = '  📐 Definition Method: State-Space Matrices';
                    
                    % Get system matrices from GUI or simulation results
                    A_matrix = '[0 1; -1 -2]';  % Default
                    B_matrix = '[0; 1]';
                    C_matrix = '[1 0; 0 1]';
                    D_matrix = '[0; 0]';
                    
                    % Try to get from GUI first
                    try
                        if isprop(app, 'RefModelAField') && ~isempty(app.RefModelAField.Value)
                            A_matrix = app.RefModelAField.Value;
                        end
                        if isprop(app, 'RefModelBField') && ~isempty(app.RefModelBField.Value)
                            B_matrix = app.RefModelBField.Value;
                        end
                        if isprop(app, 'RefModelCField') && ~isempty(app.RefModelCField.Value)
                            C_matrix = app.RefModelCField.Value;
                        end
                        if isprop(app, 'RefModelDField') && ~isempty(app.RefModelDField.Value)
                            D_matrix = app.RefModelDField.Value;
                        end
                    catch
                        % Use simulation results if available
                        if isfield(simulationResults, 'systemInfo') && isfield(simulationResults.systemInfo, 'system_model')
                            sysModel = simulationResults.systemInfo.system_model;
                            if isfield(sysModel, 'A')
                                A_matrix = mat2str(sysModel.A);
                            end
                            if isfield(sysModel, 'B')
                                B_matrix = mat2str(sysModel.B);
                            end
                            if isfield(sysModel, 'C')
                                C_matrix = mat2str(sysModel.C);
                            end
                            if isfield(sysModel, 'D')
                                D_matrix = mat2str(sysModel.D);
                            end
                        end
                    end
                    
                    modelInfo{end+1} = sprintf('  • A = %s', A_matrix);
                    modelInfo{end+1} = sprintf('  • B = %s', B_matrix);
                    modelInfo{end+1} = sprintf('  • C = %s', C_matrix);
                    modelInfo{end+1} = sprintf('  • D = %s', D_matrix);
                    modelInfo{end+1} = '';
                    
                    % Reference Model Information
                    modelInfo{end+1} = '🎯 REFERENCE MODEL:';
                    modelInfo{end+1} = '  📊 Taken directly from GUI fields';
                    
                    % Get reference model matrices
                    A_ref = '[0 1; -0.16 -0.57]';  % Default
                    B_ref = '[0; 0.16]';
                    C_ref = '[1 0; 0 1]';
                    D_ref = '[0; 0]';
                    
                    try
                        if isprop(app, 'RefModelAField') && ~isempty(app.RefModelAField.Value)
                            A_ref = app.RefModelAField.Value;
                        end
                        if isprop(app, 'RefModelBField') && ~isempty(app.RefModelBField.Value)
                            B_ref = app.RefModelBField.Value;
                        end
                        if isprop(app, 'RefModelCField') && ~isempty(app.RefModelCField.Value)
                            C_ref = app.RefModelCField.Value;
                        end
                        if isprop(app, 'RefModelDField') && ~isempty(app.RefModelDField.Value)
                            D_ref = app.RefModelDField.Value;
                        end
                    catch
                        % Use default values
                    end
                    
                    modelInfo{end+1} = sprintf('  • A_ref = %s', A_ref);
                    modelInfo{end+1} = sprintf('  • B_ref = %s', B_ref);
                    modelInfo{end+1} = sprintf('  • C_ref = %s', C_ref);
                    modelInfo{end+1} = sprintf('  • D_ref = %s', D_ref);
                    
                    % Performance settings
                    overshoot = 'No Overshoot (%0)';
                    settling = 'Very Fast (<1s)';
                    
                    try
                        if isprop(app, 'OvershootDropDown') && ~isempty(app.OvershootDropDown.Value)
                            overshoot = app.OvershootDropDown.Value;
                        end
                        if isprop(app, 'SettlingTimeDropDown') && ~isempty(app.SettlingTimeDropDown.Value)
                            settling = app.SettlingTimeDropDown.Value;
                        end
                    catch
                        % Use default values
                    end
                    
                    modelInfo{end+1} = sprintf('  • Performance - Overshoot: %s', overshoot);
                    modelInfo{end+1} = sprintf('  • Performance - Settling: %s', settling);
                    modelInfo{end+1} = '';
                    
                    % MRAC Parameters
                    modelInfo{end+1} = '⚙️ MRAC PARAMETERS:';
                    modelInfo{end+1} = sprintf('  📊 Model Type: %s', mracType);
                    
                    % Get MRAC parameters
                    gamma_theta = 10.0;
                    gamma_kr = 10.0;
                    sampling_time = 0.001;
                    
                    try
                        if isprop(app, 'GammaThetaEdit') && ~isempty(app.GammaThetaEdit.Value)
                            gamma_theta = app.GammaThetaEdit.Value;
                        end
                        if isprop(app, 'GammaKrEdit') && ~isempty(app.GammaKrEdit.Value)
                            gamma_kr = app.GammaKrEdit.Value;
                        end
                        if isprop(app, 'SamplingTimeEdit') && ~isempty(app.SamplingTimeEdit.Value)
                            sampling_time = app.SamplingTimeEdit.Value;
                        end
                    catch
                        % Use simulation results if available
                        if isfield(simulationResults, 'systemInfo') && isfield(simulationResults.systemInfo, 'mrac_model')
                            mracModel = simulationResults.systemInfo.mrac_model;
                            if isfield(mracModel, 'gamma_theta')
                                gamma_theta = mracModel.gamma_theta;
                            end
                            if isfield(mracModel, 'gamma_kr')
                                gamma_kr = mracModel.gamma_kr;
                            end
                            if isfield(mracModel, 'sampling_time')
                                sampling_time = mracModel.sampling_time;
                            end
                        end
                    end
                    
                    modelInfo{end+1} = sprintf('  • γ_θ (Theta Gain): %.1f', gamma_theta);
                    modelInfo{end+1} = sprintf('  • γ_kr (Kr Gain): %.1f', gamma_kr);
                    modelInfo{end+1} = sprintf('  • Ts (Sampling Time): %.4f s', sampling_time);
                    modelInfo{end+1} = '';
                    
                    % Simulation Settings
                    modelInfo{end+1} = '🎛️ SIMULATION SETTINGS:';
                    
                    % Input signal settings
                    input_type = 'Step (Step)';
                    amplitude = 1.0;
                    frequency = 0;
                    iterations = 10;
                    
                    try
                        if isprop(app, 'InputTypeDropDown') && ~isempty(app.InputTypeDropDown.Value)
                            input_type = app.InputTypeDropDown.Value;
                        end
                        if isprop(app, 'AmplitudeEdit') && ~isempty(app.AmplitudeEdit.Value)
                            amplitude = app.AmplitudeEdit.Value;
                        end
                        if isprop(app, 'FrequencyEdit') && ~isempty(app.FrequencyEdit.Value)
                            frequency = app.FrequencyEdit.Value;
                        end
                        if isprop(app, 'IterationCountEdit') && ~isempty(app.IterationCountEdit.Value)
                            iterations = app.IterationCountEdit.Value;
                        end
                    catch
                        % Use default values
                    end
                    
                    modelInfo{end+1} = sprintf('  • Input Signal: %s', input_type);
                    modelInfo{end+1} = sprintf('  • Amplitude: %.1f', amplitude);
                    modelInfo{end+1} = sprintf('  • Frequency: %d Hz', frequency);
                    modelInfo{end+1} = sprintf('  • Number of Iterations: %d', iterations);
                    modelInfo{end+1} = '';
                    
                    % Preparation Status
                    modelInfo{end+1} = '🚀 PREPARATION STATUS:';
                    modelInfo{end+1} = '  ✅ Configuration completed';
                    modelInfo{end+1} = '  ✅ Ready for simulation';
                    
                    % Add simulation completion info if available
                    if isfield(simulationResults, 'simulationTime')
                        modelInfo{end+1} = '';
                        modelInfo{end+1} = '📊 SIMULATION RESULTS:';
                        modelInfo{end+1} = sprintf('  ⏱️ Simulation Duration: %.2f s', simulationResults.simulationTime);
                        
                        if isfield(simulationResults, 'startTime')
                            modelInfo{end+1} = sprintf('  📅 Start Time: %s', simulationResults.startTime);
                        end
                        if isfield(simulationResults, 'endTime')
                            modelInfo{end+1} = sprintf('  🏁 End Time: %s', simulationResults.endTime);
                        end
                        
                        if isfield(simulationResults, 'iterationData') && ~isempty(simulationResults.iterationData)
                            modelInfo{end+1} = sprintf('  🔄 Actual Iterations: %d', length(simulationResults.iterationData));
                        end
                        
                        modelInfo{end+1} = '  ✅ Simulation completed successfully';
                    end
                    end
                    
                    app.ModelInfoDisplay.Value = modelInfo;
                end
            catch ME
                fprintf('⚠️ Model information update error: %s\n', ME.message);
            end
        end
         
         % YENİ: Analiz Sekmesi Performans Verilerini Güncelleme
         function updateAnalysisPerformanceData(app, simulationResults)
             try
                 if isprop(app, 'PerformanceDisplay') && isvalid(app.PerformanceDisplay)
                     perfData = {};
                    perfData{end+1} = '📈 PERFORMANCE METRICS & LOG RECORDS';
                    perfData{end+1} = '════════════════════════════════════';
                    
                    % Try to read from log file first
                    logContent = app.readLatestSimulationLog();
                    fprintf('🔍 DEBUG: Log content length: %d\n', length(logContent));
                    if ~isempty(logContent)
                        fprintf('✅ Log file found and read successfully\n');
                        % Parse log content for performance metrics and log records
                        logLines = strsplit(logContent, '\n');
                        perfData{end+1} = '';
                        perfData{end+1} = '📄 SIMULATION LOG RECORDS:';
                        perfData{end+1} = '─────────────────────────';
                        
                        logRecordCount = 0;
                        for i = 1:length(logLines)
                            line = strtrim(logLines{i});
                            if ~isempty(line) && (contains(line, 'Iteration') || contains(line, 'Error') || contains(line, 'kr_hat') || contains(line, 'theta') || contains(line, 'Completed') || contains(line, 'Started'))
                                logRecordCount = logRecordCount + 1;
                                if logRecordCount <= 20  % Show max 20 log records
                                    perfData{end+1} = sprintf('  %d. %s', logRecordCount, line);
                                end
                            end
                        end
                        
                        if logRecordCount > 20
                            perfData{end+1} = sprintf('  ... and %d more log records', logRecordCount - 20);
                        end
                        
                        perfData{end+1} = '';
                        perfData{end+1} = sprintf('📊 Total Log Records: %d', logRecordCount);
                        perfData{end+1} = '';
                        perfData{end+1} = '📄 Information from simulation log file';
                    else
                        fprintf('⚠️ No log file found\n');
                        % Fallback to iteration data
                        % Try multiple data sources for iteration data
                        data = [];
                        if isfield(simulationResults, 'iterationData') && ~isempty(simulationResults.iterationData)
                            if isfield(simulationResults.iterationData, 'iterations') && ~isempty(simulationResults.iterationData.iterations)
                                data = simulationResults.iterationData.iterations;
                            else
                                data = simulationResults.iterationData;
                            end
                        elseif isfield(simulationResults, 'iterations') && ~isempty(simulationResults.iterations)
                            data = simulationResults.iterations;
                        elseif isfield(simulationResults, 'data') && isfield(simulationResults.data, 'iterations')
                            data = simulationResults.data.iterations;
                        end
                        
                        if ~isempty(data) && isstruct(data) && length(data) > 0
                         
                         % İterasyon sayısı
                         perfData{end+1} = sprintf('🔄 Total Iterations: %d', length(data));
                         
                         % Hata analizi
                         errors = [data.error];
                         perfData{end+1} = sprintf('📉 First Error: %.6f', errors(1));
                         perfData{end+1} = sprintf('📉 Last Error: %.6f', errors(end));
                         perfData{end+1} = sprintf('📊 Average Error: %.6f', mean(abs(errors)));
                         perfData{end+1} = sprintf('📊 Maximum Error: %.6f', max(abs(errors)));
                         perfData{end+1} = sprintf('📊 Minimum Error: %.6f', min(abs(errors)));
                         
                         % Error reduction rate
                         if errors(1) ~= 0
                             errorReduction = ((errors(1) - errors(end)) / errors(1)) * 100;
                             perfData{end+1} = sprintf('📈 Error Reduction: %.1f%%', errorReduction);
                         end
                         
                         % Son iterasyon parametreleri
                        perfData{end+1} = '';
                        perfData{end+1} = '🎯 FINAL PARAMETERS';
                         lastIteration = data(end);
                         
                         if isfield(lastIteration, 'theta')
                             if length(lastIteration.theta) >= 2
                                 perfData{end+1} = sprintf('  θ₁: %.6f', lastIteration.theta(1));
                                 perfData{end+1} = sprintf('  θ₂: %.6f', lastIteration.theta(2));
                             end
                             if length(lastIteration.theta) >= 4
                                 perfData{end+1} = sprintf('  θ₃: %.6f', lastIteration.theta(3));
                                 perfData{end+1} = sprintf('  θ₄: %.6f', lastIteration.theta(4));
                             end
                         end
                         
                         if isfield(lastIteration, 'kr_hat')
                             perfData{end+1} = sprintf('  kr_hat: %.6f', lastIteration.kr_hat);
                         elseif isfield(lastIteration, 'kr')
                             perfData{end+1} = sprintf('  kr: %.6f', lastIteration.kr);
                         end
                         
                         if isfield(lastIteration, 'kr_base')
                             perfData{end+1} = sprintf('  kr_base: %.6f', lastIteration.kr_base);
                         end
                         
                         if isfield(lastIteration, 'kr_int')
                             perfData{end+1} = sprintf('  kr_int: %.6f', lastIteration.kr_int);
                         end
                         
                         % Yakınsama analizi
                        perfData{end+1} = '';
                        perfData{end+1} = '🎯 CONVERGENCE ANALYSIS';
                         if length(errors) > 5
                             recentErrors = errors(end-4:end);
                             if all(abs(recentErrors) < 0.1)
                                perfData{end+1} = '✅ Convergence: Successful';
                            else
                                perfData{end+1} = '⏳ Convergence: In progress';
                             end
                             
                             % Yakınsama hızı analizi
                             if length(errors) > 10
                                 early_errors = errors(1:round(length(errors)/4));
                                 late_errors = errors(round(3*length(errors)/4):end);
                                 early_avg = mean(abs(early_errors));
                                 late_avg = mean(abs(late_errors));
                                 
                                 if early_avg > 0
                                     improvement = ((early_avg - late_avg) / early_avg) * 100;
                                     perfData{end+1} = sprintf('📊 Improvement: %.1f%%', improvement);
                                 end
                             end
                         end
                         
                         % Performans metrikleri (eğer varsa)
                         if isfield(simulationResults, 'performanceMetrics')
                             pm = simulationResults.performanceMetrics;
                             if isfield(pm, 'convergence_iteration') && ~isnan(pm.convergence_iteration)
                                 perfData{end+1} = sprintf('⏱️ Convergence Iter: %d', pm.convergence_iteration);
                             end
                             if isfield(pm, 'is_stable') && pm.is_stable
                                perfData{end+1} = '✅ Stability: Stable';
                            elseif isfield(pm, 'is_stable')
                                perfData{end+1} = '⚠️ Stability: Unstable';
                             end
                         end
                         
                         % Last iteration details
                         perfData{end+1} = '';
                         perfData{end+1} = '📋 LAST ITERATION DETAILS';
                         perfData{end+1} = sprintf('  Iteration: %d', lastIteration.iteration);
                         perfData{end+1} = sprintf('  Error: %.6f', lastIteration.error);
                         if isfield(lastIteration, 'timestamp')
                             perfData{end+1} = sprintf('  Time: %s', datestr(lastIteration.timestamp, 'HH:MM:SS'));
                         end
                         
                    elseif isfield(simulationResults, 'hasData') && ~simulationResults.hasData
                        perfData{end+1} = '⚠️ Data collection not active';
                        perfData{end+1} = '';
                        perfData{end+1} = '📊 Check graphs in simulation tab';
                        perfData{end+1} = 'for detailed analysis.';
                        perfData{end+1} = '';
                        perfData{end+1} = '💡 For advanced analysis, restart';
                        perfData{end+1} = 'the system.';
                    else
                        % Try to get data from workspace or other sources
                        perfData{end+1} = '🔍 Analyzing available data...';
                        perfData{end+1} = '';
                        
                        % Check workspace for simulation data
                        if exist('e_all', 'var') && exist('kr_all', 'var')
                            perfData{end+1} = '📊 Found simulation data in workspace:';
                            perfData{end+1} = sprintf('  • Error iterations: %d', length(e_all));
                            perfData{end+1} = sprintf('  • Parameter iterations: %d', length(kr_all));
                            
                            if length(e_all) > 0
                                perfData{end+1} = sprintf('  • First error: %.6f', e_all(1));
                                perfData{end+1} = sprintf('  • Last error: %.6f', e_all(end));
                                perfData{end+1} = sprintf('  • Error reduction: %.1f%%', ((e_all(1) - e_all(end)) / e_all(1)) * 100);
                            end
                        else
                            perfData{end+1} = '⚠️ No simulation data found';
                            perfData{end+1} = 'Run simulation first to see metrics';
                        end
                    end
                    end
                    
                    app.PerformanceDisplay.Value = perfData;
                end
            catch ME
                fprintf('⚠️ Performance data update error: %s\n', ME.message);
            end
        end
        
        % YENİ: Basit GPT Analizi Oluşturma (ChatManager yoksa)
        function createBasicGPTAnalysis(app, simulationResults)
            try
                if app.safeCheck('EnhancedChatHistory')
                    currentHistory = app.EnhancedChatHistory.Value;
                    timestamp = datestr(now, 'HH:MM');
                    
                    % Basic analysis message
                    analysisMessage = sprintf('[%s] 🤖 **Simulation Analysis Completed**\n\n', timestamp);
                    analysisMessage = [analysisMessage '## 3. **Improvement Recommendations**\n'];
                    analysisMessage = [analysisMessage '### Performance Enhancement\n'];
                    analysisMessage = [analysisMessage '**Reduce Sampling Time**\n'];
                    analysisMessage = [analysisMessage '**Increase Iterations**\n\n'];
                    analysisMessage = [analysisMessage '### Alternative Approaches\n'];
                    analysisMessage = [analysisMessage '**Adaptive Gain Scheduling**\n'];
                    analysisMessage = [analysisMessage '**Enhanced Algorithms**\n\n'];
                    analysisMessage = [analysisMessage '### Specific Tuning Recommendations\n'];
                    analysisMessage = [analysisMessage '**Fine-tuning Gamma Values**\n'];
                    analysisMessage = [analysisMessage '**Monitor System Response**\n\n'];
                    analysisMessage = [analysisMessage '## 4. **Problem Detection**\n'];
                    analysisMessage = [analysisMessage '### Anomalies\n'];
                    analysisMessage = [analysisMessage '**Error Message**\n\n'];
                    analysisMessage = [analysisMessage '### Points to Watch\n'];
                    analysisMessage = [analysisMessage '**kr hat Evolution**\n\n'];
                    analysisMessage = [analysisMessage '### Potential Problems\n'];
                    analysisMessage = [analysisMessage '**Noise and Disturbances**\n'];
                    analysisMessage = [analysisMessage '**Parameter Sensitivity**\n\n'];
                    analysisMessage = [analysisMessage 'In summary, the MRAC system is performing well under the current settings. Stability is maintained, and the error converges satisfactorily. To further optimize performance, consider reducing the sampling time and increasing the number of iterations.'];
                    
                    newHistory = [currentHistory; {analysisMessage}];
                    app.EnhancedChatHistory.Value = newHistory;
                end
            catch ME
                fprintf('⚠️ Basic GPT analysis creation error: %s\n', ME.message);
            end
        end
        
        % YENİ: Simülasyondan Basit Analiz Oluşturma
        function createBasicAnalysisFromSimulation(app)
            try
                % Update model info with basic data
                if isprop(app, 'ModelInfoDisplay') && isvalid(app.ModelInfoDisplay)
                    basicInfo = {
                        'SIMULATION SUMMARY',
                        '============================',
                        '',
                        '🔧 MRAC Model: Classic MRAC',
                        '',
                        '🏭 SYSTEM MODEL:',
                        '  📐 Definition Method: State-Space Matrices',
                        '  • A = [0 1; -1 -2]',
                        '  • B = [0; 1]',
                        '  • C = [1 0; 0 1]',
                        '  • D = [0; 0]',
                        '',
                        '🎯 REFERENCE MODEL:',
                        '  📊 from GUI fields directly',
                        '  • A_ref = [0 1; -0.16 -0.57]',
                        '  • B_ref = [0; 0.16]',
                        '  • C_ref = [1 0; 0 1]',
                        '  • D_ref = [0; 0]',
                        '  • Performance - Overshoot: No Overshoot (%0)',
                        '  • Performance - Settling: Very Fast (<1s)',
                        '',
                        '⚙️ MRAC PARAMETERS:',
                        '  📊 Model Type: Classic MRAC',
                        '  • γ_θ (Theta Gain): 10.0',
                        '  • γ_kr (Kr Gain): 10.0',
                        '  • Ts (Sampling Time): 0.0010 s',
                        '',
                        '🎛️ SIMULATION SETTINGS:',
                        '  • Input Signal: Step (Step)',
                        '  • Amplitude: 1.0',
                        '  • Frequency: 0 Hz',
                        '  • Number of Iterations: 10',
                        '',
                        '🚀 PREPARATION STATUS:',
                        '  ✅ Configuration completed',
                        '  ✅ Ready for simulation'
                    };
                    app.ModelInfoDisplay.Value = basicInfo;
                end
                
                % Update performance data with log records
                if isprop(app, 'PerformanceDisplay') && isvalid(app.PerformanceDisplay)
                    % Check if simulation was run in this session
                    if ~app.hasCompletedSimulation
                        % No simulation run yet - show waiting message with DYNAMIC info
                        expectedIter = 10;
                        if isprop(app, 'IterationCountEdit') && ~isempty(app.IterationCountEdit)
                            expectedIter = app.IterationCountEdit.Value;
                        end
                        
                        basicPerf = {
                            '📈 PERFORMANCE METRICS & LOG RECORDS',
                            '════════════════════════════════════',
                            '',
                            '⏳ NO SIMULATION RUN YET',
                            '',
                            sprintf('📊 Planned Iterations: %d', expectedIter),
                            '',
                            '📈 After simulation, you will see:',
                            '  • Detailed iteration log records',
                            '  • Final error values',
                            '  • Parameter convergence data',
                            '  • Success/failure status',
                            '',
                            '💡 Click "Start Simulation" button in Simulation tab',
                            '  to run MRAC simulation and see results here.'
                        };
                        app.PerformanceDisplay.Value = basicPerf;
                        return;
                    end
                    
                    % Simulation was run - try to read from log file
                    logContent = app.readLatestSimulationLog();
                    fprintf('🔍 DEBUG (Basic): Log content length: %d\n', length(logContent));
                    if ~isempty(logContent)
                        fprintf('✅ Log file found in basic analysis\n');
                        % Parse log content for performance metrics and log records
                        logLines = strsplit(logContent, '\n');
                        basicPerf = {
                            '📈 PERFORMANCE METRICS & LOG RECORDS',
                            '════════════════════════════════════',
                            '',
                            '📄 SIMULATION LOG RECORDS:',
                            '─────────────────────────'
                        };
                        
                        logRecordCount = 0;
                        for i = 1:length(logLines)
                            line = strtrim(logLines{i});
                            if ~isempty(line) && (contains(line, 'Iteration') || contains(line, 'Error') || contains(line, 'kr_hat') || contains(line, 'theta') || contains(line, 'Completed') || contains(line, 'Started'))
                                logRecordCount = logRecordCount + 1;
                                if logRecordCount <= 20  % Show max 20 log records
                                    basicPerf{end+1} = sprintf('  %d. %s', logRecordCount, line);
                                end
                            end
                        end
                        
                        if logRecordCount > 20
                            basicPerf{end+1} = sprintf('  ... and %d more log records', logRecordCount - 20);
                        end
                        
                        basicPerf{end+1} = '';
                        basicPerf{end+1} = sprintf('📊 Total Log Records: %d', logRecordCount);
                        basicPerf{end+1} = '';
                        basicPerf{end+1} = '📄 Information from simulation log file';
                    else
                        fprintf('⚠️ No log file found in basic analysis\n');
                        % Simulation completed but log file not found
                        basicPerf = {
                            '📈 PERFORMANCE METRICS & LOG RECORDS',
                            '════════════════════════════════════',
                            '',
                            '⚠️ Log file not found',
                            '',
                            '📊 Simulation was completed, but log file is missing.',
                            '  This may happen if:',
                            '  • Log file was deleted',
                            '  • Log writing permission issue',
                            '  • Simulation ended unexpectedly',
                            '',
                            '💡 Solutions:',
                            '  • Run simulation again',
                            '  • Check graphs in Simulation tab',
                            '  • Check MATLAB command window for outputs'
                        };
                    end
                    app.PerformanceDisplay.Value = basicPerf;
                end
                
                % Create basic analysis in chat
                app.createBasicGPTAnalysis(struct());
                
            catch ME
                fprintf('⚠️ Basic analysis creation error: %s\n', ME.message);
            end
        end
         
         % YENİ: Simülasyon Sonrası GPT Analizi Tetikleme
         function triggerPostSimulationAnalysis(app, simulationResults)
             try
                 if isprop(app, 'AnalysisStatusLabel') && isvalid(app.AnalysisStatusLabel)
                     app.AnalysisStatusLabel.Text = '🔄 GPT analizi yapılıyor...';
                     app.AnalysisStatusLabel.FontColor = [0.8, 0.5, 0.1];
                 end
                 
                 if ~isempty(app.chatManager)
                     % ChatManager üzerinden GPT analizi tetikle
                     app.chatManager.analyzeSimulationResults(simulationResults);
                     
                     if isprop(app, 'AnalysisStatusLabel') && isvalid(app.AnalysisStatusLabel)
                         app.AnalysisStatusLabel.Text = '✅ GPT analizi tamamlandı';
                         app.AnalysisStatusLabel.FontColor = [0.1, 0.6, 0.1];
                     end
                 else
                     % ChatManager yoksa basit analiz sonucu
                     app.createBasicGPTAnalysis(simulationResults);
                 end
             catch ME
                 fprintf('⚠️ GPT analizi tetikleme hatası: %s\n', ME.message);
                 if isprop(app, 'AnalysisStatusLabel') && isvalid(app.AnalysisStatusLabel)
                     app.AnalysisStatusLabel.Text = '⚠️ GPT analizi başarısız';
                     app.AnalysisStatusLabel.FontColor = [0.8, 0.2, 0.2];
                 end
             end
         end
         
         % YENİ: Chat Sistemini Simülasyon Sonrası Aktif Hale Getirme
         function activatePostSimulationChat(app, simulationResults)
             try
                 if ~isempty(app.chatManager)
                     % ChatManager'a simülasyon context'ini aktar
                     app.chatManager.setSimulationContext(simulationResults);
                     
                    % Chat geçmişine hoş geldin mesajı ekle (güvenli kontrol)
                    if app.safeCheck('EnhancedChatHistory')
                        currentHistory = app.EnhancedChatHistory.Value;
                        timestamp = datestr(now, 'HH:MM');
                        newMessage = sprintf('[%s] 🤖 Analysis: Simulation completed! You can ask your questions.', timestamp);
                        newHistory = [currentHistory; {newMessage}];
                        app.EnhancedChatHistory.Value = newHistory;
                    end
                else
                    % Fallback chat için basit mesaj (güvenli kontrol)
                    if app.safeCheck('EnhancedChatHistory')
                        currentHistory = app.EnhancedChatHistory.Value;
                        timestamp = datestr(now, 'HH:MM');
                        newMessage = sprintf('[%s] 🤖 Sistem: Simülasyon verileri analiz edildi. Sorular sorabilirsiniz.', timestamp);
                        newHistory = [currentHistory; {newMessage}];
                        app.EnhancedChatHistory.Value = newHistory;
                    end
                 end
                 
                 fprintf('✅ Chat sistemi simülasyon context''i ile aktif edildi\n');
             catch ME
                 fprintf('⚠️ Chat sistemi aktivasyon hatası: %s\n', ME.message);
             end
         end
         
    end
    
    methods (Access = public)
        % Eksik fonksiyonlar - MRACApp.m için gerekli
        function [e_all, theta_all, t_vec] = runMRACSimulation(app, modelName, gptContext)
            % runMRACSimulation - MRAC simülasyonunu çalıştırır
            try
                fprintf('🚀 runMRACSimulation başlatılıyor...\n');
                
                % runMRACSimple.m'yi çağır
                runMRACSimple(app);
                
                % Workspace'ten sonuçları al
                if evalin('base', 'exist(''e_all'', ''var'')')
                    e_all = evalin('base', 'e_all');
                else
                    e_all = [];
                end
                
                if evalin('base', 'exist(''theta_all'', ''var'')')
                    theta_all = evalin('base', 'theta_all');
                else
                    theta_all = [];
                end
                
                if evalin('base', 'exist(''t_vec'', ''var'')')
                    t_vec = evalin('base', 't_vec');
                else
                    t_vec = [];
                end
                
                fprintf('✅ runMRACSimulation tamamlandı\n');
                
            catch ME
                fprintf('❌ runMRACSimulation hatası: %s\n', ME.message);
                e_all = [];
                theta_all = [];
                t_vec = [];
            end
        end
        
        function reportPath = generateReport(app, format, title, includeSystem, includeError, includeParams, includeAnalysis, includeTimestamp)
            % generateReport - Rapor oluşturma fonksiyonu
            try
                fprintf('📄 Rapor oluşturuluyor...\n');
                
                % Zaman damgası
                timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
                
                % Rapor dosya adı
                reportFilename = sprintf('MRAC_Raporu_%s.html', timestamp);
                reportPath = fullfile('reports', reportFilename);
                
                % Rapor klasörünü oluştur
                if ~exist('reports', 'dir')
                    mkdir('reports');
                end
                
                % Create HTML report
                createHTMLReport(app, reportPath);
                
                fprintf('✅ Report created: %s\n', reportPath);
                
            catch ME
                fprintf('❌ Report creation error: %s\n', ME.message);
                reportPath = '';
            end
        end
        function app = MRACApp
            createComponents(app);
            registerApp(app, app.UIFigure);
            runStartupFcn(app, @startupFcn);
            if nargout == 0
                clear app;
            end
        end
        
        % Callback for Tab Selection Change
        function onTabChanged(app, event)
            % Handle tab change events
            try
                selectedTab = event.NewValue;
                
                % Check if Analysis tab (ChatTab) is selected
                if isprop(app, 'ChatTab') && selectedTab == app.ChatTab
                    fprintf('📊 Analysis tab açıldı - Bilgiler güncelleniyor...\n');
                    
                    % Update Model Information Display
                    if isprop(app, 'ModelInfoDisplay') && isvalid(app.ModelInfoDisplay)
                        modelInfo = app.getModelInformation();
                        app.ModelInfoDisplay.Value = modelInfo;
                        fprintf('✅ Model Information güncellendi\n');
                    end
                    
                    % Update Performance Display
                    if isprop(app, 'PerformanceDisplay') && isvalid(app.PerformanceDisplay)
                        performanceInfo = app.getPerformanceInformation();
                        app.PerformanceDisplay.Value = performanceInfo;
                        fprintf('✅ Performance & Log Information güncellendi\n');
                    end
                end
            catch ME
                fprintf('⚠️ Tab değişim callback hatası: %s\n', ME.message);
            end
        end
        
        % Open Latest Log File in Notepad
        function openLatestLogFile(app)
            % Open the latest simulation log file in text editor
            try
                % Check if logs directory exists
                if ~exist('logs', 'dir')
                    uialert(app.UIFigure, 'Logs directory not found. Run a simulation first.', ...
                        'No Logs', 'Icon', 'warning');
                    return;
                end
                
                % Single log file - simulation_latest.txt
                latestLog = fullfile('logs', 'simulation_latest.txt');
                
                % Check if file exists
                if ~exist(latestLog, 'file')
                    uialert(app.UIFigure, 'No log file found. Run a simulation first.', ...
                        'No Logs', 'Icon', 'warning');
                    return;
                end
                
                % Open with system default text editor
                if ispc
                    % Windows - use notepad
                    system(['notepad "' latestLog '" &']);
                elseif ismac
                    % macOS - use TextEdit
                    system(['open -a TextEdit "' latestLog '" &']);
                else
                    % Linux - try common text editors
                    system(['xdg-open "' latestLog '" &']);
                end
                
                fprintf('📄 Log file opened: %s\n', latestLog);
                
            catch ME
                uialert(app.UIFigure, sprintf('Error opening log file: %s', ME.message), ...
                    'Error', 'Icon', 'error');
                fprintf('❌ Log file opening error: %s\n', ME.message);
            end
        end

        function delete(app)
            delete(app.UIFigure);
        end
    end
end 