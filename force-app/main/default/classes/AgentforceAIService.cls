public with sharing class AgentforceAIService {
    @AuraEnabled(cacheable=false)
    public static String talkToAI(String userMessage, String sessionId) {
        // TODO: Implement callout to Agentforce AI API
        return 'AI Placeholder Response for: ' + userMessage;
    }
}