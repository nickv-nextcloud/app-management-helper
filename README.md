# app-management-helper
A repository that helps doing things in many apps in one go

## Steps
1. Run `init-repositories.sh`
2. Clear the PR list file: `echo "" > pr-list.txt`
3. Use the matching `run-*.sh`, if none exist it's `run-for-all.sh $SCRIPT_NAME`
4. Post the content of `pr-list.txt` in a github issue in the server repository and ask for reviews
