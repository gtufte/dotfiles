function fish_prompt
  set -l git_branch (git branch ^/dev/null | sed -n '/\* /s///p')
  set -l git_untrackedFiles (git status ^/dev/null | sed -n '/\Untracked files/s///p')
  set -l git_unstagedCommits (git status ^/dev/null | sed -n '/\Changes to be committed/s///p')
  set -l git_uncommitedChanges (git status ^/dev/null | sed -n '/\Changes not staged for commit/s///p')
  set -l git_status (echo $git_untrackedFiles $git_unstagedCommits $git_uncommitedChanges)

  set_color 3DC7F8
  echo -n "["(whoami)
  set_color E3E3E3
  echo -n "@"
  set_color 3DC7F8
  echo -n (hostname -s)" "
  switch (pwd)
  case (echo $HOME)
    set_color B0F06C
    echo -n "~"
  case '*'
    set_color B0F06C
    echo -n (basename (pwd))
    if [ "$git_branch" != "" ]
      set_color 3DC7F8
      echo -n " | "
      if [ "$git_status" != "" ]
        set_color FC9071
      else
        set_color B0F06C
      end
      echo -n $git_branch
    end
  end
  set_color 3DC7F8
  echo -n "]# "
end
