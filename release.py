from subprocess import run
import subprocess
from os import environ, remove, chdir

input("Make sure you have commited and tagged the latest version.\nPress any key to continue, or Ctrl-C to stop")

tag = run(["git", "tag", "--contains", "HEAD"], stdout=subprocess.PIPE).stdout.decode('utf-8').split("\n")[0]
run(["git", "push"])
run(["git", "push", "--tags"])
environ["TAG"] = tag

chdir("/usr/local/Homebrew/Library/Taps/samasaur1/homebrew-core")
with open("Formula/rpg-card-generator.rb") as file:
    original = file.readlines()

output = original.copy()

remove("Formula/rpg-card-generator.rb")
run(["brew", "create", f"https://github.com/Samasaur1/RPG-card-generator/archive/{tag}.tar.gz", "--tap", "Samasaur1/core"])

with open("Formula/rpg-card-generator.rb") as file:
    data = list(file.readlines()[3:])

output[3] = data[3]
output[4] = data[4]
output[5] = f'  version "{tag[1:]}"\n'
output[6] = '  head "https://github.com/Samasaur1/RPG-card-generator.git"\n'

with open("Formula/rpg-card-generator.rb", "w") as file:
    file.writelines(output)

token = environ["GH_TOKEN"]
# run(["git", "remote", "set-url", "origin", f"https://{token}@github.com/Samasaur1/homebrew-core.git"])
run(["git", "add", "Formula/*"])
run(["git", "config", "user.name", '"Formula Bot"'])
run(["git", "config", "user.email", '"formulabot@travis-ci.com"'])
run(["git", "commit", "-m", f"Update cardgen to version {tag}"])
run(["git", "push"])

run(["sleep", "3"])
run(["killall", "Atom"])