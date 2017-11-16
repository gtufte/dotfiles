if [ -d $HOME/.rvm ]
  rvm default
end

set -gx PATH $HOME/code/dotfiles/bin $PATH
set -gx http_proxy http://www-proxy.statoil.no:80
set -gx https_proxy http://www-proxy.statoil.no:80
set -gx HTTP_PROXY http://www-proxy.statoil.no:80
set -gx HTTPS_PROXY http://www-proxy.statoil.no:80
