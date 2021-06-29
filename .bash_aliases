alias gc='cd ../../spekit-chrome-extension/src'
alias ga='cd ../../spekit-frontend-core/src'
alias gl='cd ../../lightning/src'
alias gs='cd ../../spekit-shared-components/src'
alias gu='cd ../../spekit-ui/src'
alias gd='cd ../../spekit-datalayer/src'
alias weather='curl wttr.in'

runeditor() {
  nvim "$@"
}
alias vi='runeditor'

nginxDev() {
  sudo rm /etc/nginx/sites-enabled/spekit-*
  sudo ln -s /etc/nginx/sites-available/spekit-dev /etc/nginx/sites-enabled/spekit-dev
  sudo service nginx restart
}

nginxStaging() {
  sudo rm /etc/nginx/sites-enabled/spekit-*
  sudo ln -s /etc/nginx/sites-available/spekit-staging /etc/nginx/sites-enabled/spekit-staging
  sudo service nginx restart
}

nginxProd() {
  sudo rm /etc/nginx/sites-enabled/spekit-*
  sudo ln -s /etc/nginx/sites-available/spekit-prod /etc/nginx/sites-enabled/spekit-prod
  sudo service nginx restart
}

spekit () {
  node ~/codespace/jiratools/index.js "$@"
}
