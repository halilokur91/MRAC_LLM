% MRAC_Main_Script.m
% Main script: Manages MRAC reference model and adaptation parameter selection,
% Runs adaptation loop with Simulink.
clc; clear; close all;
%% 0) Get API settings from centralized settings
fprintf('🔑 Loading API settings from centralized configuration...\n');

try
    % Try to load settings from centralized settings manager
    settingsManager = GlobalSettings();
    apiConfig = settingsManager.getApiConfig();
    
    if ~isempty(apiConfig.apiKey) && settingsManager.validateApiKey(apiConfig.apiKey)
        fprintf('✅ API key loaded from centralized settings. GPT features active.\n\n');
    else
        fprintf('⚠️ Invalid or empty API key in settings. GPT features disabled.\n\n');
        apiConfig = struct(...
            'apiKey',     'dummy-key', ...
            'model',      'gpt-4o', ...
            'temperature',0.7, ...
            'max_tokens', 700 ...
        );
    end
catch ME
    fprintf('❌ Error loading centralized settings: %s\n', ME.message);
    fprintf('⚠️ Falling back to manual input...\n\n');
    
    % Fallback to manual input
    useGptFeatures = input('Do you want to use GPT features? (y/n): ', 's');
    
    if lower(useGptFeatures) == 'y'
        apiKey = input('Enter your OpenAI API key: ', 's');
        
        if ~isempty(apiKey) && length(apiKey) > 10
            apiConfig = struct(...
                'apiKey',     apiKey, ...
                'model',      'gpt-4o', ...
                'temperature',0.7, ...
                'max_tokens', 700 ...
            );
            fprintf('✅ API key configured. GPT features active.\n\n');
        else
            fprintf('⚠️ Invalid API key. GPT features disabled.\n\n');
            apiConfig = struct(...
                'apiKey',     'dummy-key', ...
                'model',      'gpt-4o', ...
                'temperature',0.7, ...
                'max_tokens', 700 ...
            );
        end
    else
        fprintf('ℹ️ GPT features disabled. Only local calculations will be used.\n\n');
        apiConfig = struct(...
            'apiKey',     'dummy-key', ...
            'model',      'gpt-4o', ...
            'temperature',0.7, ...
            'max_tokens', 700 ...
        );
    end
end
%% Default System and Reference Models
A_sys_default = [0, 1; 0, 0];
B_sys_default = [0; 1];
C_sys_default = eye(2);     % C matrix remains 2x2 (if defined this way in your Simulink model)
D_sys_default = [0; 0];     % D matrix remains 2x1 (if defined this way in your Simulink model)

A_ref_default = [0 1; -0.16 -0.57];
B_ref_default = [0; 0.16];
C_ref_default = eye(2);     % C matrix remains 2x2
D_ref_default = [0; 0];     % D matrisi 2x1 olarak kalacak

%% Default Adaptation Parameters
kr_hat_default      = 1;
gamma_theta_default = 25000;
gamma_kr_default    = 20000;
Ts_default          = 0.001;

% theta_ başlangıç değeri (sistemde kullanılacak)
theta_ = zeros(4,1); % 4x1 boyutu sisteminizin gerektirdiği regresör boyutuna göre ayarlanmalı

% Seçilen değerleri default'lar ile başlat
kr_hat      = kr_hat_default;
gamma_theta = gamma_theta_default;
gamma_kr    = gamma_kr_default;
Ts          = Ts_default;
A_ref = A_ref_default;
B_ref = B_ref_default;
C_ref = C_ref_default;
D_ref = D_ref_default;
refModelSource = 'Varsayılan Referans Model';
% GPT ile iletişim için bağlam (context) yapısı
% Bu yapı her GPT çağrısı için güncellenecek
gptContext = struct(...
    'system_model', struct(...
        'A', A_sys_default, ...
        'B', B_sys_default, ...
        'C', C_sys_default, ...
        'D', D_sys_default ...
    ), ...
    'reference_model', struct(...
        'A', A_ref_default, ...
        'B', B_ref_default, ...
        'C', C_ref_default, ...
        'D', D_ref_default ...
    ), ...
    'adaptation_parameters', struct(...
        'kr_hat', kr_hat_default, ...
        'gamma_theta', gamma_theta_default, ...
        'gamma_kr', gamma_kr_default, ...
        'Ts', Ts_default ...
    ), ...
    'chat_history', {cell(0,1)} ... % Boş bir hücre dizisi olarak başlat
);
%% Referans Model Seçimi
fprintf('\n--- Referans Model Seçimi ---\n');
fprintf('Kontrol Edilecek Sistem Modeli (Varsayılan):\n');
fprintf('  A = %s (Tip: %s)\n', mat2str(gptContext.system_model.A), class(gptContext.system_model.A));
fprintf('  B = %s (Tip: %s)\n', mat2str(gptContext.system_model.B), class(gptContext.system_model.B));
fprintf('  C = %s (Tip: %s)\n', mat2str(gptContext.system_model.C), class(gptContext.system_model.C));
fprintf('  D = %s (Tip: %s)\n', mat2str(gptContext.system_model.D), class(gptContext.system_model.D));
fprintf('\nVarsayılan Referans Model (Hedeflenen Sistem Davranışı):\n');
fprintf('  A = %s (Tip: %s)\n', mat2str(gptContext.reference_model.A), class(gptContext.reference_model.A));
fprintf('  B = %s (Tip: %s)\n', mat2str(gptContext.reference_model.B), class(gptContext.reference_model.B));
fprintf('  C = %s (Tip: %s)\n', mat2str(gptContext.reference_model.C), class(gptContext.reference_model.C));
fprintf('  D = %s (Tip: %s)\n', mat2str(gptContext.reference_model.D), class(gptContext.reference_model.D));
confirm_default_ref = input('Varsayılan Referans Model kullanılsın mı? (y/n): ', 's');
if lower(confirm_default_ref) == "n"
    fprintf('\nVarsayılan referans model kabul edilmedi. Yeni bir referans model belirleyelim.\n');
    fprintf('a) GPT''den performans hedefleri hakkında sorular sorarak ve öneri al\n');
    fprintf('b) Manuel olarak A, B, C, D matrislerini gir\n');
    ref_choice_method = input('Seçiminiz (a/b): ', 's');
    if lower(ref_choice_method) == 'a'
        fprintf('\n--- GPT Danışmanlığı ile Referans Model Belirleme ---\n');
        
        fprintf('\nLütfen istediğiniz performans hedeflerini belirtin:\n');
        
        fprintf('1. Yükselme zamanı (rise time) ne kadar olmalı?\n');
        fprintf('   [1] Çok Hızlı (<0.5s)\n');
        fprintf('   [2] Hızlı (0.5s-1.5s)\n');
        fprintf('   [3] Orta Hızlı (1.5s-3s)\n');
        fprintf('   [4] Yavaş (>3s)\n');
        riseTimeChoice = input('Seçiminiz (1-4): ', 's');
        switch riseTimeChoice
            case '1', selectedRiseTime = 'Çok Hızlı (<0.5s)';
            case '2', selectedRiseTime = 'Hızlı (0.5s-1.5s)';
            case '3', selectedRiseTime = 'Orta Hızlı (1.5s-3s)';
            case '4', selectedRiseTime = 'Yavaş (>3s)';
            otherwise, selectedRiseTime = 'Belirtilmedi';
        end
        fprintf('\n2. Aşım oranı (overshoot) kabul edilebilir sınırlar içinde mi?\n');
        fprintf('   [1] Aşım yok (%%0)\n');
        fprintf('   [2] Düşük Aşım (Max %%5)\n');
        fprintf('   [3] Orta Aşım (Max %%15)\n');
        fprintf('   [4] Yüksek Aşım (Max %%25 üzeri)\n');
        overshootChoice = input('Seçiminiz (1-4): ', 's');
        switch overshootChoice
            case '1', selectedOvershoot = 'Aşım yok (%0)';
            case '2', selectedOvershoot = 'Düşük Aşım (Max %5)';
            case '3', selectedOvershoot = 'Orta Aşım (Max %15)';
            case '4', selectedOvershoot = 'Yüksek Aşım (Max %25 üzeri)';
            otherwise, selectedOvershoot = 'Belirtilmedi';
        end
        fprintf('\n3. Yerleşme süresi (settling time) ne kadar?\n');
        fprintf('   [1] Çok Kısa (<1s)\n');
        fprintf('   [2] Kısa (1s-3s)\n');
        fprintf('   [3] Orta (3s-7s)\n');
        fprintf('   [4] Uzun (>7s)\n');
        settlingTimeChoice = input('Seçiminiz (1-4): ', 's');
        switch settlingTimeChoice
            case '1', selectedSettlingTime = 'Çok Kısa (<1s)';
            case '2', selectedSettlingTime = 'Kısa (1s-3s)';
            case '3', selectedSettlingTime = 'Orta (3s-7s)';
            case '4', selectedSettlingTime = 'Uzun (>7s)';
            otherwise, selectedSettlingTime = 'Belirtilmedi';
        end
        requestBody = struct(...
            'context', gptContext, ...
            'request', struct(...
                'type', 'reference_model_guidance', ...
                'details', struct(...
                    'message', 'MRAC referans modeli için interaktif bir öneri istiyorum.', ...
                    'performance_goals', struct(...
                        'rise_time', selectedRiseTime, ...
                        'overshoot', selectedOvershoot, ...
                        'settling_time', selectedSettlingTime ...
                    ) ...
                )...
            )...
        );
        
        gptContext.chat_history{end+1} = struct('role', 'user', 'message', ...
            sprintf('MRAC referans modeli için bir öneri istiyorum. Performans hedeflerim: Yükselme Zamanı: %s, Aşım: %s, Yerleşme Süresi: %s.', ...
            selectedRiseTime, selectedOvershoot, selectedSettlingTime));
        jsonRequest = jsonencode(requestBody);
        jsonResponse = callGptApi_combined(jsonRequest, apiConfig);
        try
            responseStruct = jsondecode(jsonResponse);
            if strcmp(responseStruct.response.status, 'success') && strcmp(responseStruct.response.type, 'interactive_guidance')
                gptContext.chat_history{end+1} = struct('role', 'assistant', 'message', responseStruct.response.message);
                
                A_gpt_ref_sugg = responseStruct.response.data.model_A;
                B_gpt_ref_sugg = responseStruct.response.data.model_B;
                C_gpt_ref_sugg = responseStruct.response.data.model_C;
                D_gpt_ref_sugg = responseStruct.response.data.model_D;
                gpt_suggestion_desc = responseStruct.response.data.description;
                fprintf('\nGPT''nin Seçimlerinize Göre Önerisi (%s):\n', gpt_suggestion_desc);
                fprintf('  A = %s (Tip: %s)\n', mat2str(A_gpt_ref_sugg), class(A_gpt_ref_sugg));
                fprintf('  B = %s (Tip: %s)\n', mat2str(B_gpt_ref_sugg), class(B_gpt_ref_sugg));
                fprintf('  C = %s (Tip: %s)\n', mat2str(C_gpt_ref_sugg), class(C_gpt_ref_sugg));
                fprintf('  D = %s (Tip: %s)\n', mat2str(D_gpt_ref_sugg), class(D_gpt_ref_sugg));
                
                confirm_gpt_sugg = input('Bu GPT önerisi kullanılsın mı? (y/n, Manuel için Enter): ', 's');
                if lower(confirm_gpt_sugg) == 'y'
                    A_ref = A_gpt_ref_sugg;
                    B_ref = B_gpt_ref_sugg;
                    C_ref = C_gpt_ref_sugg;
                    D_ref = D_gpt_ref_sugg;
                    refModelSource = 'GPT Danışmanlığı ile Belirlenen';
                    gptContext.reference_model.A = A_ref;
                    gptContext.reference_model.B = B_ref;
                    gptContext.reference_model.C = C_ref;
                    gptContext.reference_model.D = D_ref;
                else
                    fprintf('\nGPT önerisi kabul edilmedi. Manuel giriş moduna geçiliyor.\n');
                    ref_choice_method = 'b';
                end
            else
                fprintf('GPT''den beklenmeyen bir yanıt formatı alındı veya öneri bulunamadı. Manuel girişe devam ediliyor.\n');
                fprintf('GPT Mesajı: %s\n', responseStruct.response.message);
                ref_choice_method = 'b';
            end
        catch ME
            fprintf('GPT yanıtı işlenirken bir hata oluştu: %s\n', ME.message);
            fprintf('Hata detayı: %s\n', ME.message);
            fprintf('Manuel girişe devam ediliyor.\n');
            ref_choice_method = 'b';
        end
    end
    if lower(ref_choice_method) == 'b'
        fprintf('\n--- Manuel Referans Model Girişi ---\n');
        fprintf('Lütfen referans modelin A, B, C, D matrislerini girin.\n');
        fprintf('Örnek matris girişi: [1 2; 3 4]\n');
        
        try
            A_ref = input('A matrisi: ');
            B_ref = input('B matrisi: ');
            C_ref = input('C matrisi: ');
            D_ref = input('D matrisi: ');
            refModelSource = 'Manuel Giriş';
            gptContext.reference_model.A = A_ref;
            gptContext.reference_model.B = B_ref;
            gptContext.reference_model.C = C_ref;
            gptContext.reference_model.D = D_ref;
        catch ME
            error('Geçersiz matris girişi. Lütfen MATLAB matris formatına uygun girin. Hata: %s', ME.message);
        end
    end
elseif lower(confirm_default_ref) == 'y'
    refModelSource = 'Varsayılan Referans Model';
    gptContext.reference_model.A = A_ref;
    gptContext.reference_model.B = B_ref;
    gptContext.reference_model.C = C_ref;
    gptContext.reference_model.D = D_ref;
else
    error('Geçersiz seçim. Lütfen "y" veya "n" girin.');
end
fprintf('\n--- Referans Model Seçimi Özeti ---\n');
fprintf('Seçilen Referans Model Kaynağı: %s\n', refModelSource);
fprintf('Seçilen Referans Model Parametreleri:\n');
fprintf('  A = %s (Tip: %s)\n', mat2str(A_ref), class(A_ref));
fprintf('  B = %s (Tip: %s)\n', mat2str(B_ref), class(B_ref));
fprintf('  C = %s (Tip: %s)\n', mat2str(C_ref), class(C_ref));
fprintf('  D = %s (Tip: %s)\n', mat2str(D_ref), class(D_ref));
fprintf('Kontrol Edilecek Sistem Modeli (Varsayılan):\n');
fprintf('  A = %s (Tip: %s)\n', mat2str(A_sys_default), class(A_sys_default));
fprintf('  B = %s (Tip: %s)\n', mat2str(B_sys_default), class(B_sys_default));
fprintf('  C = %s (Tip: %s)\n', mat2str(C_sys_default), class(C_sys_default));
fprintf('  D = %s (Tip: %s)\n', mat2str(D_sys_default), class(D_sys_default));
%% Adaptasyon Parametreleri Seçimi
fprintf('\n--- Adaptasyon Parametreleri Seçimi ---\n');
fprintf('Varsayılan Adaptasyon Parametreleri:\n');
fprintf('  kr_hat = %.3f (Tip: %s)\n', kr_hat_default, class(kr_hat_default));
fprintf('  gamma_theta = %.3f (Tip: %s)\n', gamma_theta_default, class(gamma_theta_default));
fprintf('  gamma_kr = %.3f (Tip: %s)\n', gamma_kr_default, class(gamma_kr_default));
fprintf('  Ts = %.4f (Tip: %s)\n', Ts_default, class(Ts_default));
fprintf('\nAdaptasyon parametreleri için GPT''den öneri almak ister misiniz? (y/n, Varsayılan için Enter): ');
confirm_gpt_adapt_params = input('', 's'); 
if lower(confirm_gpt_adapt_params) == 'y'
    fprintf('\n--- GPT''den Adaptasyon Parametreleri Önerisi Alınıyor ---\n');
    
    requestBody = struct(...
        'context', gptContext, ...
        'request', struct(...
            'type', 'adaptation_parameters_suggestion', ...
            'details', struct(...
                'message', 'Daha iyi performans veya kararlılık için alternatif adaptasyon parametreleri önerir misiniz?' ...
            )...
        )...
    );
    gptContext.chat_history{end+1} = struct('role', 'user', 'message', requestBody.request.details.message);
    jsonRequest = jsonencode(requestBody);
                jsonResponse = callGptApi_combined(jsonRequest, apiConfig);
    try
        responseStruct = jsondecode(jsonResponse);
        if strcmp(responseStruct.response.status, 'success') && strcmp(responseStruct.response.type, 'adaptation_parameters_suggestion')
            gptContext.chat_history{end+1} = struct('role', 'assistant', 'message', responseStruct.response.message);
            kr_hat_gpt      = responseStruct.response.data.param_kr_hat;
            gamma_theta_gpt = responseStruct.response.data.param_gamma_theta;
            gamma_kr_gpt    = responseStruct.response.data.param_gamma_kr;
            Ts_gpt          = responseStruct.response.data.param_Ts;
            gpt_suggestion_desc = responseStruct.response.data.description;
            fprintf('\nGPT''nin Önerisi (%s):\n', gpt_suggestion_desc);
            fprintf('  kr_hat=%.3f (Tip: %s), gamma_theta=%.3f (Tip: %s), gamma_kr=%.3f (Tip: %s), Ts=%.4f (Tip: %s)\n', ...
                kr_hat_gpt, class(kr_hat_gpt), gamma_theta_gpt, class(gamma_theta_gpt), ...
                gamma_kr_gpt, class(gamma_kr_gpt), Ts_gpt, class(Ts_gpt));
            
            confirm_gpt_params = input('Bu GPT önerisi kullanılsın mı? (y/n, Varsayılan için Enter): ', 's');
            if lower(confirm_gpt_params) == "y"
                kr_hat      = kr_hat_gpt;
                gamma_theta = gamma_theta_gpt;
                gamma_kr    = gamma_kr_gpt;
                Ts          = Ts_gpt;
                gptContext.adaptation_parameters.kr_hat = kr_hat;
                gptContext.adaptation_parameters.gamma_theta = gamma_theta;
                gptContext.adaptation_parameters.gamma_kr = gamma_kr;
                gptContext.adaptation_parameters.Ts = Ts;
            end
        else
            fprintf('GPT''den beklenmeyen bir yanıt formatı alındı veya öneri bulunamadı. Varsayılanlar kullanılıyor.\n');
            fprintf('GPT Mesajı: %s\n', responseStruct.response.message);
        end
    catch ME
        fprintf('GPT yanıtı işlenirken bir hata oluştu: %s\n', ME.message);
        fprintf('Hata detayı: %s\n', ME.message);
        fprintf('Varsayılanlar kullanılıyor.\n');
    end
end
fprintf('\nManuel Ayarlama İçin Alternatif Adaptasyon Parametreleri (Dilerseniz Mevcut Değerleri Değiştirin):\n');
manualOptionLetter = 'a';
fprintf(' %s) Mevcut Değerleri Manuel Ayarla\n', manualOptionLetter);
selPar = input(sprintf('Seçiminiz (%s veya Enter ile mevcut değeri kullan): ', manualOptionLetter), 's');
if lower(selPar) == manualOptionLetter
    fprintf('\nMevcut Adaptasyon Parametrelerini Ayarlayın:\n');
    kr_hat_new = input(sprintf('kr_hat (Mevcut: %.3f) = ', kr_hat));
    if ~isempty(kr_hat_new), kr_hat = kr_hat_new; end % Eğer kullanıcı boş bırakırsa mevcut değeri koru
    gamma_theta_new = input(sprintf('gamma_theta (Mevcut: %.3f) = ', gamma_theta));
    if ~isempty(gamma_theta_new), gamma_theta = gamma_theta_new; end
    gamma_kr_new = input(sprintf('gamma_kr (Mevcut: %.3f) = ', gamma_kr));
    if ~isempty(gamma_kr_new), gamma_kr = gamma_kr_new; end
    Ts_new = input(sprintf('Ts (Mevcut: %.4f) = ', Ts));
    if ~isempty(Ts_new), Ts = Ts_new; end
    
    gptContext.adaptation_parameters.kr_hat = kr_hat;
    gptContext.adaptation_parameters.gamma_theta = gamma_theta;
    gptContext.adaptation_parameters.gamma_kr = gamma_kr;
    gptContext.adaptation_parameters.Ts = Ts;
elseif isempty(selPar)
    % Kullanıcı Enter'a bastı, mevcut değerleri (default veya GPT önerisi) kullan
    % Zaten ayarlanmış durumda, hiçbir şey yapmaya gerek yok.
else
    error('Geçersiz seçim.');
end
fprintf('\n--- Adaptasyon Parametreleri Seçimi Özeti ---\n');
fprintf('  kr_hat = %.3f (Tip: %s)\n', kr_hat, class(kr_hat));
fprintf('  gamma_theta = %.3f (Tip: %s)\n', gamma_theta, class(gamma_theta));
fprintf('  gamma_kr = %.3f (Tip: %s)\n', gamma_kr, class(gamma_kr));
fprintf('  Ts = %.4f (Tip: %s)\n', Ts, class(Ts));


%% Simulink Modeli Yükleniyor ve Yapılandırılıyor
fprintf('\n--- Simulink Modeli Yükleniyor ve Yapılandırılıyor ---\n');
modelName = 'E_MRAC2bb';
open_system(modelName);
% Referans modeli Simulink'e aktar
blk_ref_model_path = [modelName '/State-Space1']; % Simulink'teki referans model bloğunuzun yolu
set_param(blk_ref_model_path, 'A', mat2str(A_ref), 'B', mat2str(B_ref), 'C', mat2str(C_ref), 'D', mat2str(D_ref));
% Adaptasyon parametrelerini base workspace'e ve Simulink'e aktar
% Simulink modelinizde bu isimlerde Constant veya Gain blokları olduğundan emin olun.
assignin('base', 'kr_hat', kr_hat);
assignin('base', 'theta_', theta_); % theta_ başlangıç değeri
assignin('base', 'Ts', Ts);
% Eğer Simulink modelinizde kr_hat ve theta_ için doğrudan "Constant" blokları varsa,
% onların değerini set_param ile güncelleyebilirsiniz:
% set_param([modelName '/kr_hat_block'], 'Value', num2str(kr_hat));
% set_param([modelName '/theta_block'], 'Value', mat2str(theta_));
% **NOT:** Eğer bu bloklar yoksa veya farklı bir şekilde kullanılıyorsa, yukarıdaki 'assignin' yeterli olacaktır.
% Ancak modelinizde bu parametreleri doğrudan görselleştirmek veya ayırmak isterseniz bu blokları eklemeniz gerekir.
%% Log Dosyaları Başlatılıyor
logCsvFile  = 'iteration_data.csv';
fid_csv  = fopen(logCsvFile, 'w');
if fid_csv == -1
    error('Log dosyası açılamadı: %s', logCsvFile);
end
fprintf(fid_csv, 'iter,kr_hat,theta1,theta2,theta3,theta4,r_mean,eTPB_mean\n');
%% MRAC Adaptasyon Döngüsü Başlatılıyor
max_iterations = 100;
e_all     = zeros(max_iterations, 1);
theta_all = zeros(max_iterations, numel(theta_)); 
fprintf('\n--- MRAC Adaptasyon Döngüsü Başlatılıyor ---\n');
for iteration = 1:max_iterations
    fprintf('Iterasyon: %d/%d\n', iteration, max_iterations);
    
    % Adaptasyon parametrelerini Simulink'e güncelleyin (Constant blokları için)
    % Eğer modelinizde 'kr_hat' ve 'theta_' adında Constant blokları varsa bu satırlar çalışır.
    % Yoksa bu satırları yorum satırı yapın, assignin yeterlidir.
    set_param([modelName '/kr_hat'], 'Value', num2str(kr_hat));
    set_param([modelName '/theta_'], 'Value', mat2str(theta_)); % theta_ bir vektör olduğu için mat2str kullanılır.
    
    % Simulink modelini çalıştır.
    % Simulink modelinizin "To Workspace" blokları çıktıları doğrudan base workspace'e kaydetmeli.
    sim(modelName); % 'ReturnWorkspaceOutputs' yoksa çıktılar base workspace'e gelir.
    
    % Simulink çıktılarını kontrol et ve kullan
    % Bu kısım, Simulink'ten gelen değişkenlerin (phi, r, eTPB) tipine göre hassastır.
    % Eğer Timeseries objesi olarak geliyorlarsa `.Data`'ya ihtiyacımız var.
    % Eğer doğrudan matris/array olarak geliyorlarsa `.Data`'ya gerek yok.
    
    % Timeseries kontrolü ve veri çekme
    % --- phi verisini çek ---
    if exist('phi','var')
        if isa(phi,'timeseries')
            phi_data = phi.Data;    % Timeseries ise Data
        elseif isnumeric(phi)
            phi_data = squeeze(phi);% Numeric ise fazladan boyutları at
        else
            error('phi beklenmedik bir tipte: %s', class(phi));
        end
    else
        error('Simulink çıktısında phi bulunamadı.');
    end
    
    % GÜNCELLENDİ: r ve eTPB'nin '120001x1 double' olarak geldiği varsayımıyla düzeltmeler.
    % Bu, C=eye(2) tanımlamasına rağmen Simulink'ten tek çıktı geldiği anlamına gelir.
    % Eğer C=eye(2) kullanıp 2 çıktı istiyorsanız Simulink'i düzenlemelisiniz.
    
    if exist('r', 'var') %
        if isa(r, 'timeseries') %
            r_data = r.Data; %
        elseif isnumeric(r) && isvector(r) % % Eğer 'r' numeric ve tek boyutlu (sütun veya satır vektör) ise
            r_data = r; %
        else
            error('Simulink çıktısı "r" base workspace''de beklenen tipte veya boyutta değil. Timeseries, skaler veya vektör olması bekleniyor.'); %
        end
    else
        error('Simulink çıktısı "r" base workspace''de bulunamadı.'); %
    end
    
    if exist('eTPB', 'var') %
        if isa(eTPB, 'timeseries') %
            eTPB_data = eTPB.Data; %
        elseif isnumeric(eTPB) && isvector(eTPB) % % Eğer 'eTPB' numeric ve tek boyutlu (sütun veya satır vektör) ise
            eTPB_data = eTPB; %
        else
            error('Simulink çıktısı "eTPB" base workspace''de beklenen tipte veya boyutta değil. Timeseries, skaler veya vektör olması bekleniyor.'); %
        end
    else
        error('Simulink çıktısı "eTPB" base workspace''de bulunamadı.'); %
    end
    
    % squeeze ve mean işlemleri
    % phi_mat'ın doğru boyutlara sahip olduğundan emin olun.
    % Eğer Simulink'ten gelen phi_data zaten NxM veya Nx1 ise squeeze gereksiz olabilir.
    phi_mat     = squeeze(phi_data);
    
    % GÜNCELLENDİ: r_data ve eTPB_data'nın artık tek boyutlu vektörler olduğu varsayımıyla.
    % mean() tek boyutlu bir vektör için tek bir skaler ortalama dönecektir.
    r_scalar    = mean(r_data); %
    eTPB_scalar = mean(eTPB_data); %
    
    % phi_vector tanımını düzeltme (son zaman adımındaki regresör vektörünü al)
    % phi_mat'ın boyutu 4xZaman_Adımı ise, son sütun son zaman adımındaki vektördür.
    phi_vector = phi_mat(:, end); % Son sütunu (son zaman adımını) al ve zaten sütun vektörüdür.
    
    % Adaptasyon Kuralları (Referans Modelli Adaptif Kontrol için)
    kr_dot  = -gamma_kr * r_scalar * eTPB_scalar;
    kr_hat  = kr_hat + Ts * kr_dot;
    
    theta_dot = -gamma_theta * eTPB_scalar * phi_vector;
    theta_    = theta_ + Ts * theta_dot;
    
    % Adaptasyon parametrelerini sınırla (gerekiyorsa)
    theta_ = max(min(theta_, 10), -10); % Örneğin, theta'yı -10 ile 10 arasında sınırla
    kr_hat = max(min(kr_hat, 50), 0);   % Örneğin, kr_hat'ı 0 ile 50 arasında sınırla
    
    % Güncellenmiş adaptasyon parametrelerini base workspace'e tekrar atayın
    assignin('base','kr_hat', kr_hat);
    assignin('base','theta_', theta_);
    
    %% Loglama: Her iterasyondaki parametreleri ve hataları CSV'ye kaydet
    fprintf(fid_csv, '%d,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f\n', ...
        iteration, kr_hat, theta_(1), theta_(2), theta_(3), theta_(4), r_scalar, eTPB_scalar);
    
    %% Analiz Verilerini Depolama
    e_all(iteration)          = eTPB_scalar;
    theta_all(iteration, :) = theta_';
end
fclose(fid_csv); % Log dosyasını kapat
%% Performans Grafikleri
fprintf('\n--- Simülasyon Sonuçları: Performans Grafikleri ---\n');
% Iterasyon başına hata eğrisi
figure;
subplot(2, 1, 1);
plot(1:max_iterations, e_all, '-o', 'LineWidth', 2);
xlabel('Iterasyon');
ylabel('Ortalama Hata (eTPB)');
title('MRAC Hata Eğrisi (Her Iterasyon İçin Ortalama)');
grid on;
% Theta parametrelerinin konverjansı
subplot(2, 1, 2);
plot(1:max_iterations, theta_all, 'LineWidth', 2);
xlabel('Iterasyon');
ylabel('\theta Adaptif Parametreleri');
legend('\theta_1', '\theta_2', '\theta_3', '\theta_4', 'Location', 'best');
title('Theta Konverjansı');
grid on;
fprintf('\nSimülasyon tamamlandı. Sonuçlar "%s" dosyasına kaydedildi ve grafikler çizildi.\n', logCsvFile);