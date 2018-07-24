[![Build Status](https://travis-ci.org/ballerina-guides/playground-async-invocation.svg?branch=master)](https://travis-ci.org/ballerina-guides/playground-async-invocation)

# Ballerina Playground - Async Service Invocation 

## <a name="what-you-build"></a> What you’ll build 

In this example you will use Ballerina to invoke an remote service asynchronously, continue on with the work 
related to the main worker and once it is completed, then process the response that has received asynchronously. 
 
## <a name="pre-req"></a> Prerequisites
- JDK 1.8 or later
- [Ballerina Distribution](https://github.com/ballerina-lang/ballerina/blob/master/docs/quick-tour.md)
- A Text Editor or an IDE 

## <a name="developing-service"></a> Developing the service 

**This is a Ballerina playground example. You can try it at  [ballerina.io](https://ballerina.io).**
 
### <a name="invoking"></a> Invoking the service

```
curl http://localhost:9090/quote
``` 
