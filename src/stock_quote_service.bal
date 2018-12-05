import ballerina/http;
import ballerina/io;
import ballerina/runtime;


// ***** This service acts as a backend and is not exposed via playground samples ******

listener http:Listener ep = new(9095);

@http:ServiceConfig {basePath:"/nasdaq/quote"}
service time on ep {
    @http:ResourceConfig{
        path: "/GOOG",  methods: ["GET"]
    }
    resource function sayHello(http:Caller caller, http:Request request) {
        string googQuote = "GOOG, Alphabet Inc., 1013.41";
        runtime:sleep(1000);
        _ = caller->respond(googQuote);
    }
}
