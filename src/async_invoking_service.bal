import ballerina/http;
import ballerina/io;
import ballerina/runtime;

@http:ServiceConfig {
    basePath:"/quote"
}
service<http:Service> AsyncInvoker bind {} {

  @http:ResourceConfig {
      methods:["GET"],
      path:"/"
  }
  getQuote (endpoint caller, http:Request req) {
    endpoint http:SimpleClient nasdaqServiceEP {
      url:"http://localhost:9095"
    };

    io:println(" >> Invoking service asynchrnounsly...");

    // 'async' allows you to invoke a function or client
    // connector action asynchronously. This is a remote
    // invocation that returns without waiting for response.
    future<http:Response | http:HttpConnectorError> f1
      = start nasdaqServiceEP
            -> get("/nasdaq/quote/GOOG", new);
    io:println(" >> Invocation completed!"
      + " Proceed without blocking for a response.");

    // Mimic the workload of the main worker with a loop
    int i = 0;
    while (i < 3) {
      io:println(" >> Do some work."
                 + "... Step " + i);
      i = i + 1;
      runtime:sleepCurrentWorker(200);
    }

    io:println(" >> Check for response availability...");

    // ‘await` blocks until the previously started
    // async function returns.
    var response = await f1;
    io:println(" >> Response available! ");
    match response {
      http:Response resp => {
        string responseStr = check resp.getStringPayload();
        io:println(" >> Response : "
                   + responseStr);
        _ = caller -> respond(resp);
      }
      http:HttpConnectorError err => {
        io:println(err.message);
      }
    }
  }
}


