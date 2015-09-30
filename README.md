# JSLocalURLCache
网络缓存到本地

在wifi的情况下会自动清理缓存然后重新加载，该功能需要第三方Reachability

***

# 问题

有网络的环境下缓存到本地后，断网重新打开依然能够读取到本地的缓存

但是将Demo合到别的应用内，缓存后断网重新加载，一直进入

	-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error

**该问题还没有想通，正在研究中**





