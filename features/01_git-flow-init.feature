Feature: Test GitFlow init commands

    Background:
        Given I am running GitFlow commands

    Scenario: Init git flow repository
        When I run `git flow init`
        Then the exit status should be 0
        And the output should contain "Initialized empty Git repository"

    Scenario: Run git flow init on a git flow initd directory
        When I run `git flow init`
        And I run `git flow init`
        Then the output from "git flow init" should contain "Already initialized for gitflow"

    Scenario: Re-initialise git flow
        When I run `git flow init`
        And I run `git flow init -f`
        Then the output from "git flow init -f" should not contain "Already initialized for gitflow"
        And the output from "git flow init -f" should contain "Branch name for production releases"

