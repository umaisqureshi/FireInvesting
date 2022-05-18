// TODO: You will need to get your own API keys in order to run this project.
// TODO: Remove the 'package:MOT/key.dart' package and replace the varibales' value with your own API keys.
// The reason why the package in under is missing is because that's where I, (Joshua Garcia), store my API keys.
// You do not need to create a new package key.dart because this is the one we will be using to store our keys. 

/// Sentry DNS is used to track errors. It is beeing used at [SentryHelper].
/// To get your DNS, go to: https://sentry.io/. 
/// Create a project and follow these steps: https://forum.sentry.io/t/where-can-i-find-my-dsn/4877
const String kSentryDomainNameSystem = "sentryDNS";

/// The Alpha Vantage API is used to power the Search Section.
/// It is used at [SearchClient]. 
/// To get your own API key go to: https://www.alphavantage.co.
const String kAlphaVantageKey = "HZZ1BG5FTBFW758K";

/// The Finnhub Stock API is used to power the news section in the [ProfileSection] page.
/// It is used at [ProfileClient]. 
/// To get your own API key go to: https://finnhub.io.
const String kFinnhubKey = "c08mup748v6vku8umqp0";

/// The News API is used to power the news section.
/// It is used at [NewsClient]. 
/// To get your own API key go to: https://newsapi.org.
const String kNewsKey = "1f60890cb7f14aebb40bd68b52295d41";

/// Financial Modeling Prep API is used to power the Home, U.S Market and Profile Section.
/// Now an API key is required which means that we won't be able to make infinite requests. :(
/// To get your own API key go to: https://financialmodelingprep.com/developer/docs/
const String kFinancialModelingPrepApi = "11463d5cecc58cda357fc74bde98ecbe";
const String kIexApiToken  = "pk_47dbd72058034359b200a8d29675d3f3";