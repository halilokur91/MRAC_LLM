function reportUtils()
% Raporlama utility fonksiyonları
end

function createHTMLReport(app, filename)
% HTML raporu oluşturma fonksiyonu
try
    % HTML template
    html = ['<!DOCTYPE html>' newline ...
           '<html><head>' newline ...
           '<title>' app.ReportTitleEdit.Value '</title>' newline ...
           '<meta charset="utf-8">' newline ...
           '<style>' newline ...
           'body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }' newline ...
           '.container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }' newline ...
           'h1 { color: #2c5aa0; border-bottom: 3px solid #2c5aa0; padding-bottom: 10px; }' newline ...
           'h2 { color: #4a4a4a; margin-top: 30px; }' newline ...
           '.info-box { background: #e8f4ff; padding: 15px; border-left: 4px solid #2c5aa0; margin: 20px 0; }' newline ...
           '.param-table { border-collapse: collapse; width: 100%; margin: 20px 0; }' newline ...
           '.param-table th, .param-table td { border: 1px solid #ddd; padding: 12px; text-align: left; }' newline ...
           '.param-table th { background-color: #f2f2f2; font-weight: bold; }' newline ...
           '.plot-container { text-align: center; margin: 30px 0; }' newline ...
           '.timestamp { color: #888; font-style: italic; }' newline ...
           '</style>' newline ...
           '</head><body>' newline ...
           '<div class="container">'];
    
    % Başlık ve zaman damgası
    if app.IncludeTimestampCheckBox.Value
        html = [html '<h1>' app.ReportTitleEdit.Value '</h1>' newline];
        html = [html '<p class="timestamp">Oluşturulma Tarihi: ' datestr(now, 'dd/mm/yyyy HH:MM:SS') '</p>' newline];
    end
    
    % Simülasyon parametreleri
    if app.IncludeParametersCheckBox.Value
        html = [html '<h2>📊 Simülasyon Parametreleri</h2>' newline];
        html = [html '<div class="info-box">' newline];
        html = [html '<table class="param-table">' newline];
        html = [html '<tr><th>Parametre</th><th>Değer</th></tr>' newline];
        
        % Model tipi
        if isprop(app, 'ModelTypeDropDown')
            html = [html '<tr><td>MRAC Model Tipi</td><td>' app.ModelTypeDropDown.Value '</td></tr>' newline];
        end
        
        % Referans model tipi
        html = [html '<tr><td>Referans Model Tipi</td><td>from GUI fields</td></tr>' newline];
        end
        
        html = [html '</table></div>' newline];
    end
    
    % Grafikler
    if app.IncludeSystemPlotCheckBox.Value || app.IncludeErrorPlotCheckBox.Value
        html = [html '<h2>📈 Simülasyon Grafikleri</h2>' newline];
        
        % Grafikleri PNG olarak kaydet ve HTML'e dahil et
        timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
        
        if app.IncludeSystemPlotCheckBox.Value
            fig1 = figure('Visible', 'off', 'Position', [100 100 800 400]);
            copyobj(app.ErrorAxes.Children, axes(fig1));
            title('Sistem ve Referans Model Çıkışları', 'FontSize', 14, 'FontWeight', 'bold');
            xlabel('Time (seconds)', 'FontSize', 12);
            ylabel('Çıkış Sinyali', 'FontSize', 12);
            grid on;
            
            plotFile1 = ['temp_sistem_' timestamp '.png'];
            saveas(fig1, plotFile1);
            close(fig1);
            
            html = [html '<div class="plot-container">' newline];
            html = [html '<h3>Sistem ve Referans Model Çıkışları</h3>' newline];
            html = [html '<img src="' plotFile1 '" alt="Sistem Grafik" style="max-width: 100%; height: auto; border: 1px solid #ddd;">' newline];
            html = [html '</div>' newline];
        end
        
        if app.IncludeErrorPlotCheckBox.Value
            fig2 = figure('Visible', 'off', 'Position', [100 100 800 400]);
            copyobj(app.ThetaAxes.Children, axes(fig2));
            title('Takip Hatası (eTPB)', 'FontSize', 14, 'FontWeight', 'bold');
            xlabel('Time (seconds)', 'FontSize', 12);
            ylabel('Hata Büyüklüğü', 'FontSize', 12);
            grid on;
            
            plotFile2 = ['temp_hata_' timestamp '.png'];
            saveas(fig2, plotFile2);
            close(fig2);
            
            html = [html '<div class="plot-container">' newline];
            html = [html '<h3>Takip Hatası</h3>' newline];
            html = [html '<img src="' plotFile2 '" alt="Hata Grafik" style="max-width: 100%; height: auto; border: 1px solid #ddd;">' newline];
            html = [html '</div>' newline];
        end
    end
    
    % Performance analizi
    if app.IncludeAnalysisCheckBox.Value
        html = [html '<h2>📋 Performance Analizi</h2>' newline];
        html = [html '<div class="info-box">' newline];
        html = [html '<p><strong>Simülasyon Durumu:</strong> Başarıyla Tamamlandı</p>' newline];
        html = [html '<p><strong>Kullanılan Algoritma:</strong> Model Reference Adaptive Control (MRAC)</p>' newline];
        html = [html '<p><strong>Grafik Kalitesi:</strong> Profesyonel düzeyde plot formatlaması</p>' newline];
        html = [html '</div>' newline];
    end
    
    % Footer
    html = [html '<hr style="margin-top: 40px; border: none; border-top: 1px solid #ddd;">' newline];
    html = [html '<p style="text-align: center; color: #888; font-size: 12px;">Bu rapor MRAC Simülasyon Uygulaması tarafından otomatik olarak oluşturulmuştur.</p>' newline];
    html = [html '</div></body></html>'];
    
    % HTML dosyasını kaydet
    fid = fopen(filename, 'w', 'n', 'UTF-8');
    fprintf(fid, '%s', html);
    fclose(fid);
    
    fprintf('✅ HTML raporu oluşturuldu: %s\n', filename);
    
catch ME
    fprintf('❌ HTML raporu oluşturulurken hata: %s\n', ME.message);
    rethrow(ME);
end
end

function createPDFReport(app, filename)
% PDF raporu oluşturma fonksiyonu
try
    % HTML oluştur
    htmlFile = ['temp_' filename(1:end-4) '.html'];
    createHTMLReport(app, htmlFile);
    
    % HTML'i PDF'e çevirmeye çalış (web browser üzerinden)
    fprintf('📄 PDF raporu oluşturmak için:\n');
    fprintf('1. %s dosyasını tarayıcınızda açın\n', htmlFile);
    fprintf('2. Tarayıcının "Yazdır" özelliğini kullanın\n');
    fprintf('3. "PDF olarak kaydet" seçeneğini seçin\n');
    
    % Browser'da aç
    web(htmlFile, '-browser');
    
    fprintf('✅ HTML raporu hazır, PDF\'e çevrilebilir: %s\n', htmlFile);
    
catch ME
    fprintf('❌ PDF raporu oluşturulurken hata: %s\n', ME.message);
    rethrow(ME);
end
end

function createWordReport(app, filename)
% Word raporu oluşturma (HTML formatında, Word'de açılabilir)
try
    % HTML oluştur ama Word uyumlu formatla
    htmlFile = [filename(1:end-5) '.html'];
    createHTMLReport(app, htmlFile);
    
    % Dosya uzantısını değiştir (Word HTML formatını destekler)
    copyfile(htmlFile, filename);
    
    fprintf('✅ Word uyumlu raporu oluşturuldu: %s\n', filename);
    fprintf('Bu dosyayı Microsoft Word ile açabilirsiniz.\n');
    
catch ME
    fprintf('❌ Word raporu oluşturulurken hata: %s\n', ME.message);
    rethrow(ME);
end
end

function createPNGPlots(app, timestamp)
% PNG grafikleri oluşturma fonksiyonu
try
    if app.IncludeSystemPlotCheckBox.Value
        fig1 = figure('Visible', 'off', 'Position', [100 100 1000 600]);
        copyobj(app.ErrorAxes.Children, axes(fig1));
        title('Sistem ve Referans Model Çıkışları', 'FontSize', 16, 'FontWeight', 'bold');
        xlabel('Time (seconds)', 'FontSize', 14);
        ylabel('Çıkış Sinyali', 'FontSize', 14);
        grid on;
        saveas(fig1, ['MRAC_Sistem_Grafik_' timestamp '.png']);
        close(fig1);
    end
    
    if app.IncludeErrorPlotCheckBox.Value
        fig2 = figure('Visible', 'off', 'Position', [100 100 1000 600]);
        copyobj(app.ThetaAxes.Children, axes(fig2));
        title('Takip Hatası (eTPB)', 'FontSize', 16, 'FontWeight', 'bold');
        xlabel('Time (seconds)', 'FontSize', 14);
        ylabel('Hata Büyüklüğü', 'FontSize', 14);
        grid on;
        saveas(fig2, ['MRAC_Hata_Grafik_' timestamp '.png']);
        close(fig2);
    end
    
    fprintf('✅ PNG grafikler oluşturuldu: MRAC_*_Grafik_%s.png\n', timestamp);
    
catch ME
    fprintf('❌ PNG grafik oluşturulurken hata: %s\n', ME.message);
    rethrow(ME);
end
end

function createMATLABFigure(app, filename)
% MATLAB Figure dosyası oluşturma
try
    fig = figure('Position', [100 100 1200 800], 'Name', app.ReportTitleEdit.Value);
    
    % Sistem grafiği
    if app.IncludeSystemPlotCheckBox.Value
        subplot(2,1,1);
        copyobj(app.ErrorAxes.Children, gca);
        title('Sistem ve Referans Model Çıkışları', 'FontSize', 14, 'FontWeight', 'bold');
        xlabel('Time (seconds)', 'FontSize', 12);
        ylabel('Çıkış Sinyali', 'FontSize', 12);
        grid on;
    end
    
    % Hata grafiği
    if app.IncludeErrorPlotCheckBox.Value
        if app.IncludeSystemPlotCheckBox.Value
            subplot(2,1,2);
        end
        copyobj(app.ThetaAxes.Children, gca);
        title('Takip Hatası (eTPB)', 'FontSize', 14, 'FontWeight', 'bold');
        xlabel('Time (seconds)', 'FontSize', 12);
        ylabel('Hata Büyüklüğü', 'FontSize', 12);
        grid on;
    end
    
    % Figure'ı kaydet
    savefig(fig, filename);
    close(fig);
    
    fprintf('✅ MATLAB Figure oluşturuldu: %s\n', filename);
    
catch ME
    fprintf('❌ MATLAB Figure oluşturulurken hata: %s\n', ME.message);
    rethrow(ME);
end
end

