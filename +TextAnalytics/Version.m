function V = Version
V.Me='v1.0.3';
V.MATLAB='R2021a';
persistent NewVersion
if isempty(NewVersion)
	NewVersion=TextAnalytics.CheckUpdateFromGitHub('https://github.com/Silver-Fang/Text-Analytics/releases','埃博拉酱的文本分析工具箱',V.Me);
end