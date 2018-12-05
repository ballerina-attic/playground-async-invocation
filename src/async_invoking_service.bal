import ballerina/http;
import ballerina/log;
import ballerina/runtime;

listener http:Listener ep = new(9090);

@http:ServiceConfig {
    basePath:"/quote"
}
service AsyncInvoker on ep {

  @http:ResourceConfig {
      methods:["GET"],
      path:"/"
  }
  resource function getQuote(http:Caller caller, http:Request req) {
    http:Client nasdaqServiceEP = new("http://localhost:9095");


    log:printInfo(" >> Invoking service asynchronously...");

    // 'start' invokes a function or action asynchronously. Returns
    // a 'future' without waiting for response.
    future<http:Response | error> f1 =
      start nasdaqServiceEP->get("/nasdaq/quote/GOOG");

    log:printInfo(" >> Invocation initiated!");

    int i = 0;
    while (i < 3) {
      log:printInfo(" >> Do some work.... Step " + i);
      i = i + 1;
      runtime:sleep(200);
    }

    log:printInfo(" >> Checking for a response from the future...");

    // 'await' blocks until the started async function returns
    var response = wait f1;
    log:printInfo(" >> Response available!");
    if (response is http:Response) {
        var payload = response.getTextPayload();
        if (payload is string) {
          log:printInfo(" >> Response : " + payload);
          _ = caller->respond(response);
        } else if (payload is error) {
          sendErrorResponse(caller, payload);
        }
    } else if (response is error) {
      sendErrorResponse(caller, response);
    }
  }
}

function sendErrorResponse(http:Caller caller, error err) {
  http:Response res= new;
  res.statusCode = 500;
  res.setPayload(untaint string.convert(err.detail().message));
  _ = caller->respond(res);
}
