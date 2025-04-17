/**
 * Service class for making callouts to the Jira API
 */
public with sharing class JiraAPIService {
	/**
	 * Creates a project in Jira
	 * @param projectWrapper The project wrapper object containing all necessary data
	 * @return String The Jira project ID
	 *
	 * TODO: Implement this method to make a callout to Jira API to create a project
	 * Reminder: Extract and return the project ID from the response
	 */

	private static final String API_NAMED_CREDENTIAL = 'callout:Jira';
	public static String createProject(JiraWrapper.ProjectWrapper projectWrapper) {
		String body = JSON.serialize(projectWrapper);

		HttpRequest req = new HttpRequest();
		req.setEndpoint('Callout:Jira');
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/json');
		req.setBody(body);

		Http http = new Http();
		HttpResponse res = http.send(req);
		if (res.getStatusCode() >= 200 && res.getStatusCode() <= 299) {
			System.debug('Callout Success Response: ' + res.getBody());
		} else {
			System.debug(
				'Callout Error: ' +
					res.getStatusCode() +
					' ' +
					res.getStatus() +
					' ' +
					res.getBody()
			);
		}

		//Now parse the response to get the project ID
		Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
			res.getBody()
		);
		String projectId = String.valueOf(responseMap.get('id'));

		return projectId;
	}

	/**
	 * Creates an issue in Jira
	 * @param issueWrapper The issue wrapper object containing all necessary data
	 * @return String The Jira issue key
	 *
	 * TODO: Implement this method to make a callout to Jira API to create an issue
	 * Reminder: Extract and return the issue key from the response
	 */
	public static String createIssue(JiraWrapper.IssueWrapper issueWrapper) {
		String body = JSON.serialize(issueWrapper.generateIssuePayloadMap(issueWrapper));

		Logger.debug('Callout Body: ' + body);

		HttpRequest req = new HttpRequest();
		req.setEndpoint('Callout:JiraIssues');
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/json');
		req.setBody(body);

		Http http = new Http();
		HttpResponse res = http.send(req);
		if (res.getStatusCode() >= 200 && res.getStatusCode() <= 299) {
			Logger.debug('Callout Success Response: ' + res.getBody());
		} else {
			Logger.debug('Callout Error: ' + res.getStatusCode() + ' ' + res.getStatus());
		}
		Logger.saveLog();

		//Now parse the response to get the project ID
		Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
			res.getBody()
		);
		String issueKey = String.valueOf(responseMap.get('key'));

		return issueKey;
	}
}