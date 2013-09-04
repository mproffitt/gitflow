Feature: Test GitFlow hotfix commands

    Background:
        Given I am running GitFlow commands

    Scenario: Run git flow hotfix start without branch name
        When I run `git flow init`
        And I run `git flow hotfix start`
        Then the exit status should be 1
        And the output should contain "Missing argument <version>"

    Scenario: Create hotfix branch
        When I run `git flow init`
        And I run `git flow hotfix start JIRA-1234-mp-test-hotfix`
        And I run `git rev-parse --abbrev-ref HEAD`
        Then the output from "git rev-parse --abbrev-ref HEAD" should contain exactly "hotfix-JIRA-1234-mp-test-hotfix\n"

    Scenario: Try to create hotfix branch when branch exists with same name
        When I run `git flow init`
        And I run `git flow hotfix start JIRA-1234-mp-test-hotfix`
        And I run `git flow hotfix start JIRA-1234-mp-test-hotfix`
        Then the exit status should be 1
        And the output should contain "There is an existing hotfix branch (JIRA-1234-mp-test-hotfix)"

    Scenario: Finish hotfix branch
        When I run `git flow init`
        And I run `git flow hotfix start JIRA-1234-mp-test-hotfix`
        And I run `git flow hotfix finish JIRA-1234-mp-test-hotfix`
        And I run `git branch`
        And I run `git rev-parse --abbrev-ref HEAD`
        Then the output from "git flow hotfix finish JIRA-1234-mp-test-hotfix" should contain "Finished hotfix hotfix-JIRA-1234-mp-test-hotfix"
        And the output from "git branch" should not contain "hotfix-JIRA-1234-mp-test-hotfix"
        And the output from "git rev-parse --abbrev-ref HEAD" should contain exactly "develop\n"


