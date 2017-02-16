function fish_prompt
  set -l git_branch (git branch ^/dev/null | sed -n '/\* /s///p')
  set -l git_untrackedFiles (git status ^/dev/null | sed -n '/\Untracked files/s///p')
  set -l git_unstagedCommits (git status ^/dev/null | sed -n '/\Changes to be committed/s///p')
  set -l git_uncommitedChanges (git status ^/dev/null | sed -n '/\Changes not staged for commit/s///p')
  set -l git_status (echo $git_untrackedFiles $git_unstagedCommits $git_uncommitedChanges)

#  set -l env_prd (hostname | grep 'prd\|prod')
#  set -l env_stg (hostname | grep 'stg\|beta')
#  set -l env_dev (hostname | grep 'dev')
#  if [ "$env_prd" != "" ]
#    set env_color D8000C
#  else if [ "$env_stg" != "" ]
#    set env_color FEEFB3
#  else if [ "$env_dev" != "" ]
#    set env_color BDE5F8
#  else
#    set env_color D8000C
#  end

  set env_color BDE5F8

  set_color $env_color
  echo -n "["(whoami)
  set_color d3d3d3
  echo -n "@"
  set_color $env_color
  echo -n (hostname)" "
  switch (pwd)
  case (echo $HOME)
    set_color B0F06C
    echo -n "~"
  case '*'
    set_color B0F06C
    echo -n (basename (pwd))
    if [ "$git_branch" != "" ]
      set_color d3d3d3
      echo -n " | "
      if [ "$git_status" != "" ]
        set_color FC9071
      else
        set_color B0F06C
      end
      echo -n $git_branch
    end
  end
  set_color $env_color
  echo -n "]# "
end
