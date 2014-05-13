#Cinnamon

Cinnamon is a Force.com native app that enables you to build and execute Selenium-based GUI tests from within your Salesforce org to validate Visualforce pages in your Salesforce org.

* Create and execute Selenium Tests from within your Salesforce org
* Out-of-box integration with Sauce Labs which provides comprehensive OS/Browser coverage
* Connect to any of your Salesforce DE or Sandbox org via OAuth authentication
* Provide PageObject support to help develop maintainable test code to interact with your Visualforce pages

##Install
Cinnamon requiers installing the following two pacakges

1. Install [Apex Selenium package](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t30000001I916)
2. Install [Cinnamon package](https://login.salesforce.com/packaging/installPackage.apexp?p0=04td0000000N0pW)

##Setup
Select `Cinnamon` from App dropdown

Go to "Settings" and provide the following Selenium config settings and enter your Sauce Labs username & access key

* Selenium Proxy URL `ondemand.saucelabs.com`
* Selenium Port `80`
* Sauce Username `<Your Sauce Username>`
* Sauce Access Key `<Your Sauce Access Key>`

*Click [here](https://saucelabs.com/signup) to sign up a Free Sauce Labs account if you don't have one.

![](https://raw.githubusercontent.com/ryojiosawa/cinnamon/master/img/cinnamon_settings.png)

Go to "Remote Site Settings" and update `self` setting to your instance
 * You can find your instance by checking the URL of  your org.  For example, if the URL is `https://na15.salesforce.com`, your org resides in `na15` instance.
 ![](https://raw.githubusercontent.com/ryojiosawa/cinnamon/master/img/self_remote_site.png)

###Connect to your org under test
1. Click `Connect to Your Org Under Test` button
![](https://raw.githubusercontent.com/ryojiosawa/cinnamon/master/img/org_under_test.png)
2. Login to Your Org Under Test and click `Allow` button
![](https://raw.githubusercontent.com/ryojiosawa/cinnamon/master/img/login_dialogue.png)
3. After authentication is complete successfully, you will see Cinnamon being connected to your Org Under Test
![](https://raw.githubusercontent.com/ryojiosawa/cinnamon/master/img/org_under_test2.png)

###Run a sample Cinnamon Test
1. Go to `Setup -> Develop -> Apex Classes` and create a new Class `TestSampleCinnamonTest` and paste the following [sample code](https://gist.github.com/ryojiosawa/9750540)
2. Go to `Test Console` tab
![](https://raw.githubusercontent.com/ryojiosawa/cinnamon/master/img/testconsole.png)
3. Select `TestSampleCinnamonTest` and click `Execute Test button`
4. The sample test executed successfully
![](https://raw.githubusercontent.com/ryojiosawa/cinnamon/master/img/test_passed.png)
5. Click Pass link to view the test execution detail
![](https://raw.githubusercontent.com/ryojiosawa/cinnamon/master/img/testdetail.png)

##Issues/Bugs
Use [Github Issues](https://github.com/ryojiosawa/cinnamon/issues) to log and track issues and bugs
