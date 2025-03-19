import OpenAI from "openai";
import { openaiKey } from "../config";

const openai = new OpenAI({
    apiKey: openaiKey,
});

export const generateDailyQuestion = async (): Promise<string> => {
    try{
        const response = await openai.chat.completions.create({
            model:'gpt-4',
            messages: [
                {role: 'user', content: 'Generate a fun and engaging daily question for a chat conversation.'}
            ],
            max_tokens: 50
        });
        console.log("generateDailyQuestion - openAi called :");
        console.log(response.choices[0]?.message?.content);
        
        return response.choices[0]?.message?.content?.trim() || "What's your favorite hobby?";
    } catch(error) {
        console.error('Error generating daily question:', error);
        return "Here is a random question: What's your favorite book?";
    }
}