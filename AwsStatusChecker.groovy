def services = ['s3', 'elasticache', 'management-console', 'cloudwatch', 'ec2', 'elb', 'rds', 'route53', 'vpc', 'iam', 'all']
def regions = ['us-east-1', 'us-west-1', 'us-west-2', 'us-standard']
def baseUrl = 'http://status.aws.amazon.com/rss/'

if (! args) {
    println "Usage: "
    println "'groovy aws_status_checker.groovy [arg1] [arg2]'  arg1 = service, arg2 = region"
    return 1
}

def givenService = args[0]
def givenRegion

if (args.length > 1) {
  givenRegion = args[1]
}

def url = baseUrl

if (! givenRegion || givenService == 'management-console' || givenService == 'route53') {
    url += givenService
} else {
    url += givenService + '-' + givenRegion
}

url = url + '.rss'

def status = 'AWS Unknown: Script Error!'

try {
    url.toURL().withReader { r ->
	def feed = new XmlSlurper(false, false).parse(r).channel.item.first()
	def title = feed.title.toString()
	if (title.startsWith('Service is operating normally') || title.startsWith('Service disruption: [RESOLVED]')) {
	status = 'AWS OK'
	} else if (title.startsWith('Informational Message') || title.startsWith('Performance Issues')) {
	status = 'AWS Warning'
	} else if (title.startsWith('Service disruption')) {
	status = 'AWS Critical'
	} else {
	status = 'AWS Unknown'
	}
    }
} catch (FileNotFoundException e) {
  println "File Could not be found. Check region/service and try again?"
  println "URL: $url"
} catch (NoSuchElementException e) {
  status = 'AWS OK: No events to display.'
}

println status
return status
