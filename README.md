# 📧 Email Spam Reporter 🚨

This is a Sinatra app that listens for incoming email bounce and complaint notifications and reports them in a Slack channel. It can help you keep track of your email deliverability issues and take action to improve it.

## Features 🔥

✅ Receives incoming email bounce and complaint notifications via HTTP POST requests

✅ Sends a Slack alert with the email address included in the payload if the email is reported as spam

✅ Logs errors and exceptions to the console and returns appropriate status codes

✅ Protected by SSL/TLS for secure communication

✅ Enables HTTP Strict Transport Security (HSTS) for additional security

✅ Includes a health check endpoint

## Getting Started 🏁

### Prerequisites

Before running this application, make sure you have the following installed:

- Ruby 2.7.2 or higher
- Bundler

### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/AgoraSecurity/simple_api
    ```

1. Install the dependencies:

    ```bash
    cd simple_api
    bundle install
    ```

1. Set up the required environment variables:

    ```bash
    cp .env.example .env
    ```

    Then fill in the .env file with the necessary values for your environment.

1. Start the application:

    ```bash
    ruby app.rb
    ```

The application will start at http://localhost:4567 by default.

That's it! The application should now be running locally on your machine.

## Usage 📖

Send a POST request to the `/payload` endpoint with a JSON payload that looks like this:

```json
{
  "RecordType": "Bounce",
  "Type": "SpamNotification",
  "TypeCode": 512,
  "Name": "Spam notification",
  "Tag": "",
  "MessageStream": "outbound",
  "Description": "The message was delivered, but was either blocked by the user, or classified as spam, bulk mail, or had rejected content.",
  "Email": "zaphod@example.com",
  "From": "notifications@honeybadger.io",
  "BouncedAt": "2023-02-27T21:41:30Z",
}
```

Example cURL request:

```bash
curl -X POST https://example.com/payload \
-H 'Content-Type: application/json' \
-d '{
  "RecordType": "Bounce",
  "Type": "SpamNotification",
  "TypeCode": 512,
  "Name": "Spam notification",
  "Tag": "",
  "MessageStream": "outbound",
  "Description": "The message was delivered, but was either blocked by the user, or classified as spam, bulk mail, or had rejected content.",
  "Email": "zaphod@example.com",
  "From": "notifications@honeybadger.io",
  "BouncedAt": "2023-02-27T21:41:30Z",
}'
```

## Production-Ready 🚀

To make this application production-ready, consider implementing the following:

**Security**: Add additional security measures, such as authentication and authorization, to ensure that only authorized users can access the application. This can be done by adding basic authentication, API keys, or other secure access mechanisms.

**Error Handling and Logging**: Implement more advanced error handling and logging to help you diagnose and fix issues that may arise in production. This can include logging to a file or external service, setting up alerts for critical errors, and implementing retry logic to handle transient errors.

**Monitoring and Metrics**: Set up monitoring and metrics to help you track the health and performance of your application. This can include setting up alerts for high error rates or slow response times, and using metrics to identify performance bottlenecks and optimize your application.

**Deployment**: Use a reliable deployment process to deploy your application to production, such as using a containerization platform like Docker or a cloud-based service like AWS Elastic Beanstalk. This will help ensure that your application is deployed consistently and reliably across different environments.

**Scalability**: Design your application to be scalable, so that it can handle increasing traffic and load over time. This can include using load balancers, caching, and other performance optimizations to ensure that your application can handle high levels of traffic without slowing down or crashing.
