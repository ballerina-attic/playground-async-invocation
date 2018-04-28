import ballerina/http;
import ballerina/io;
import ballerina/runtime;

endpoint http:Listener listener {
  port:9090
};

@http:ServiceConfig {
    basePath:"/quote"
}
service<http:Service> AsyncInvoker bind listener {

  @http:ResourceConfig {
      methods:["GET"],
      path:"/"
  }
  getQuote (endpoint caller, http:Request req) {
    endpoint http:Client nasdaqServiceEP {
      url:"http://localhost:9095"
    };

    io:println(" >> Invoking service asynchrnounsly...");

    // 'start' allows you to invoke a function or client
    // connector action asynchronously. This is a remote
    // invocation that returns without waiting for response.
    future<http:Response | error> f1
      = start nasdaqServiceEP
            -> get("/nasdaq/quote/GOOG");
    io:println(" >> Invocation completed!"
      + " Proceed without blocking for a response.");

    // Mimic the workload of the main worker with a loop.
    int i = 0;
    while (i < 3) {
      io:println(" >> Do some work.... Step " + i);
      i = i + 1;
      runtime:sleep(200);
    }

    io:println(" >> Check for response availability...");

    // ‘await` blocks until the previously started async
    // function returns.
    var response = await f1;
    io:println(" >> Response available! ");
    match response {
      http:Response resp => {
        string responseStr = check resp.getTextPayload();
        io:println(" >> Response : "
                   + responseStr);
        _ = caller -> respond(resp);
      }
      error err => {
        io:println(err.message);
      }
    }
  }
}
