/**
 * Helper class for Jira triggers
 */
public with sharing class JiraTriggerHelper {
	/**
	 * Process Jira_Project__c records after insert
	 * @param newProjects List of newly inserted Jira_Project__c records
	 */
	public static void processProjectAfterInsert(List<Jira_Project__c> newProjects) {
		List<Jira_Project__c> projectsToProcess = new List<Jira_Project__c>();

		// Filter out projects that already have a Jira project ID
		for (Jira_Project__c project : newProjects) {
			if (String.isBlank(project.Project_ID__c)) {
				JiraCalloutQueueable callout = new JiraCalloutQueueable(
					project.Id,
					project.Project_Name__c,
					project.Project_Key__c,
					project.Description__c
				);

				if (!Test.isRunningTest()) {
					System.enqueueJob(callout);
				}
			}

			System.debug(
				'Project to process: ' +
					project.Id +
					' ' +
					project.Project_Name__c +
					' ' +
					project.Project_Key__c +
					' ' +
					project.Description__c
			);
		}
	}

	/**
	 * Process Jira_Issue__c records after insert
	 * @param newIssues List of newly inserted Jira_Issue__c records
	 *
	 * TODO: Implement this method to process new Jira issues
	 * The method should:
	 * 1. Filter out issues that already have a Jira issue key
	 * 2. Ensure the Project_Key__c field is not blank
	 * 3. Create a JiraCalloutQueueable for each issue and enqueue it
	 * 4. Don't enqueue if Test.isRunningTest() is true
	 */
	public static void processIssueAfterInsert(List<Jira_Issue__c> newIssues) {
		for (Jira_Issue__c issue : newIssues) {
			if (String.isBlank(issue.Issue_Key__c) && String.isNotBlank(issue.Project_Key__c)) {
				// Enqueue the callout
				JiraCalloutQueueable callout = new JiraCalloutQueueable(
					issue.Id,
					issue.Project_Key__c,
					issue.Summary__c,
					issue.Description__c,
					issue.Issue_Type__c
				);

				if (!Test.isRunningTest()) {
					System.enqueueJob(callout);
				}
			}
			Logger.debug(
				'Jira Issue to process: ' +
					issue.Id +
					' ' +
					issue.Summary__c +
					' ' +
					issue.Description__c +
					' ' +
					issue.Issue_Type__c
			);
			Logger.saveLog();
		}
	}
}
