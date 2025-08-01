% LMS Noise Reduction Script

[y, Fs] = audioread("dammm.wav"); % Load audio
SNR = 10;
noisy_signal = awgn(y, SNR); % Add noise

filter_length = 256;
mu = 0.01;
lms_filter = dsp.LMSFilter(filter_length, 'StepSize', mu);

desired_signal = y;
error_signal = zeros(size(y));
output_signal = zeros(size(y));

for i = 1:length(y)
    [output, error] = step(lms_filter, noisy_signal(i), desired_signal(i));
    output_signal(i) = output;
    error_signal(i) = error;
end

t = (0:length(y)-1)/Fs;

figure;
plot(t, y); title('Original Signal'); xlabel('Time'); ylabel('Amplitude');
saveas(gcf, 'plots/original_signal.png');

figure;
plot(t, noisy_signal); title('Noisy Signal'); xlabel('Time'); ylabel('Amplitude');
saveas(gcf, 'plots/noisy_signal.png');

figure;
plot(t, output_signal); title('Corrected Signal'); xlabel('Time'); ylabel('Amplitude');
saveas(gcf, 'plots/corrected_signal.png');

sound(y, Fs); pause(length(y)/Fs + 1);
sound(noisy_signal, Fs); pause(length(noisy_signal)/Fs + 1);
sound(output_signal, Fs);
