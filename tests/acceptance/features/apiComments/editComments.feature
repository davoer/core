@api @TestAlsoOnExternalUserBackend @comments-app-required @skipOnOcis @issue-ocis-reva-38
Feature: Comments

  Background:
    Given using new DAV path
    And these users have been created with default attributes and skeleton files:
      | username |
      | user0    |
      | user1    |

  @smokeTest
  Scenario Outline: Edit my own comments on a file belonging to myself
    Given user "user0" has uploaded file "filesForUpload/textfile.txt" to "/myFileToComment.txt"
    And user "user0" has commented with content "File owner comment" on file "/myFileToComment.txt"
    When user "user0" edits the last created comment with content "<comment>" using the WebDAV API
    Then the HTTP status code should be "207"
    And user "user0" should have the following comments on file "/myFileToComment.txt"
      | user  | comment   |
      | user0 | <comment> |
    Examples:
      | comment           |
      | My edited comment |
      | 😀 🤖             |
      | नेपालि            |

  @files_sharing-app-required
  Scenario: Edit my own comments on a file shared by someone with me
    Given user "user0" has uploaded file "filesForUpload/textfile.txt" to "/myFileToComment.txt"
    And user "user0" has shared file "/myFileToComment.txt" with user "user1"
    And user "user1" has commented with content "Sharee comment" on file "/myFileToComment.txt"
    When user "user1" edits the last created comment with content "My edited comment" using the WebDAV API
    Then the HTTP status code should be "207"
    And user "user1" should have the following comments on file "/myFileToComment.txt"
      | user  | comment           |
      | user1 | My edited comment |

  @files_sharing-app-required
  Scenario: Editing comments of other users should not be possible
    Given user "user0" has uploaded file "filesForUpload/textfile.txt" to "/myFileToComment.txt"
    And user "user0" has shared file "/myFileToComment.txt" with user "user1"
    And user "user1" has commented with content "Sharee comment" on file "/myFileToComment.txt"
    And user "user0" should have the following comments on file "/myFileToComment.txt"
      | user  | comment        |
      | user1 | Sharee comment |
    When user "user0" edits the last created comment with content "User1 edited comment" using the WebDAV API
    Then the HTTP status code should be "403"
    And user "user0" should have the following comments on file "/myFileToComment.txt"
      | user  | comment        |
      | user1 | Sharee comment |

  Scenario: Edit my own comments on a folder belonging to myself
    Given user "user0" has created folder "/FOLDER_TO_COMMENT"
    And user "user0" has commented with content "Folder owner comment" on folder "/FOLDER_TO_COMMENT"
    When user "user0" edits the last created comment with content "My edited comment" using the WebDAV API
    Then the HTTP status code should be "207"
    And user "user0" should have the following comments on folder "/FOLDER_TO_COMMENT"
      | user  | comment           |
      | user0 | My edited comment |
