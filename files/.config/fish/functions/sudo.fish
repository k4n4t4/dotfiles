function sudo -d "sudo wrapper that handles aliases"

  if functions -q -- $argv[1]
    set -l new_args (string join ' ' -- (string escape -- $argv))
    set argv fish -c "$new_args"
  end

  command sudo -p "Password: " $argv
end
