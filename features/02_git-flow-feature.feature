Feature: Test GitFlow feature commands

    Background:
        Given I am running GitFlow feature commands

    Scenario: Run git flow feature start without branch name
        When I run `git flow init`
        And I run `git flow feature start`
        Then the exit status should be 1
        And the output should contain "Missing argument <name>"

    Scenario: Create feature branch
        When I run `git flow init`
        And I run `git flow feature start JIRA-1234-mp-test-feature`
        And I run `git rev-parse --abbrev-ref HEAD`
        Then the output from "git rev-parse --abbrev-ref HEAD" should contain exactly "feature-JIRA-1234-mp-test-feature\n"

    Scenario: Try to create feature branch when branch exists with same name
        When I run `git flow init`
        And I run `git flow feature start JIRA-1234-mp-test-feature`
        And I run `git flow feature start JIRA-1234-mp-test-feature`
        Then the exit status should be 1
        And the output should contain "Branch 'feature-JIRA-1234-mp-test-feature' already exists. Pick another name"

    Scenario: Finish feature branch
        When I run `git flow init`
        And I run `git flow feature start JIRA-1234-mp-test-feature`
        And I run `git flow feature finish JIRA-1234-mp-test-feature`
        And I run `git branch`
        And I run `git rev-parse --abbrev-ref HEAD`
        Then the exit status should be 0
        And the output from "git flow feature finish JIRA-1234-mp-test-feature" should contain "Finished feature feature-JIRA-1234-mp-test-feature"
        And the output from "git flow feature finish JIRA-1234-mp-test-feature" should contain "The feature branch 'feature-JIRA-1234-mp-test-feature' was merged into 'develop'"
        And the output from "git branch" should contain "feature-JIRA-1234-mp-test-feature"
        And the output from "git rev-parse --abbrev-ref HEAD" should contain exactly "develop\n"

    Scenario: Clean up feature branch
        When I run `git flow init`
        And I run `git flow feature start JIRA-1234-mp-test-feature`
        And I run `git flow feature finish JIRA-1234-mp-test-feature`
        And I run `git flow feature cleanup -a JIRA-1234-mp-test-feature`
        Then the exit status should be 0
        And the output should contain "Summary of actions:"
        And the output should contain "Feature branch 'feature-JIRA-1234-mp-test-feature' has been removed"

    Scenario: Clean up feature and add release management task
        When I run `git flow init`
        And I run `git flow feature start JIRA-1234-mp-test-feature`
        And I run `git flow feature finish JIRA-1234-mp-test-feature`
        And I run `git flow feature cleanup -a JIRA-1234-mp-test-feature RM-34`
        Then the exit status should be 0
        And the output should contain "Added aruba to list of release repos"
        And the output should contain "Linked feature JIRA-1234 to RM-34"

    Scenario: Clean up feature and add release management task
        When I run `git flow init`
        And I run `git flow feature start JIRA-1234-mp-test-feature`
        And I run `git flow feature finish JIRA-1234-mp-test-feature`
        And I run `git flow feature cleanup -a JIRA-1234-mp-test-feature RM-34`
        Then the exit status should be 0
        And the output should contain "Not adding aruba - already added"
        And the output should contain "Feature JIRA-1234 has already been linked to RM-34"

