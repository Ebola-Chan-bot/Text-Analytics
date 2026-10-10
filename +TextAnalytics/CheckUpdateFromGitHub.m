%[text] 从 GitHub Release 检查更新
%[text] 此函数从 GitHub Release 页面抓取最新版本发布Tag，与输入的版本号比较，如果不相同，则认为存在新版本，在命令行窗口显示一条更新提醒。
%[text] 此函数不能在线程并行池中使用。如果使用，不会报错，将发出警告并返回missing。
%[text] ## 语法
%[text] ```matlabCodeExample
%[text] NewVersion=TextAnalysis.CheckUpdateFromGitHub(ReleaseUrl,PackageName,CurrentVersion);
%[text] ```
%[text] ## 示例
%[text] ```matlabCodeExample
%[text] %如下代码，可以放在你的包经常用到的函数中启动，使用persistent确保每个MATLAB会话只检查一次，不会频繁打扰用户
%[text] persistent NewVersion
%[text] if isempty(NewVersion)
%[text] 	NewVersion=TextAnalytics.CheckUpdateFromGitHub('https://github.com/Ebola-Chan-bot/Text-Analytics/releases','埃博拉酱的文本分析工具箱','v1.0.0');
%[text] end
%[text] ```
%[text] ## 输入参数
%[text] ReleaseUrl(1,1)string，发布包的 GitHub Release URL
%[text] PackageName(1,1)string，要检查更新的包名
%[text] CurrentVersion(1,1)string，要检查是否最新的当前版本号
%[text] ## 返回值
%[text] NewVersion(1,1)string，检查到的最新版本号
function NewVersion=CheckUpdateFromGitHub(ReleaseUrl,PackageName,CurrentVersion)
NewVersion=missing;
try
	Releases=webread(ReleaseUrl);
catch ME
	if any(ME.identifier==["MATLAB:webservices:ConnectionRefused","MATLAB:webservices:UnknownHost","MATLAB:webservices:Timeout","MATLAB:webservices:SSLConnectionSystemFailure"])
		warning(ME.identifier,ME.identifier);
		return;
	else
		ME.rethrow;
	end
end
try
	Releases=htmlTree(Releases);
catch ME
	if ME.identifier=="MATLAB:undefinedVarOrClass"
		TextAnalytics.Exception.Thread_parallelism_not_supported.Warn;
		return;
	else
		ME.rethrow;
	end
end
Releases=Releases.findElement('div[data-hpc] section');
for R=1:numel(Releases)
	if ~isempty(Releases(R).findElement('.Label--success'))
		NewVersion=Releases(R).findElement('a[href*="/releases/tag/"]').extractHTMLText;
		if ~strcmp(NewVersion,CurrentVersion)
			fprintf('%s%s已发布，<a href="%s">立即更新</a>\n',PackageName,NewVersion,ReleaseUrl);
		end
		return;
	end
end
TextAnalytics.Exception.Latest_release_not_found.Warn;

%[appendix]{"version":"1.0"}
%---
