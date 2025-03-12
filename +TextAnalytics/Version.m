function V = Version
V.Me='v1.0.4';
V.MATLAB='R2023b';
V.MatlabExtension='16.0.0';
persistent NewVersion
if isempty(NewVersion)
	NewVersion=TextAnalytics.CheckUpdateFromGitHub('https://github.com/Ebola-Chan-bot/Text-Analytics/releases','埃博拉酱的文本分析工具箱',V.Me);
end