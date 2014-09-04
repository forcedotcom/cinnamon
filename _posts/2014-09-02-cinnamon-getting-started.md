---
layout: news_item
title: 'Getting Started with Cinnamon Testing'
date: 2014-09-02
author: jheritagesf
---

Now that you've set up your Cinnamon environment, it's time to start writing some tests! This page provides an overview of important concepts in Cinnamon testing as well as an example of a basic Cinnamon test.
</p>

<p>
	The first step in writing a Cinnamon test is identifying particular pages and objects in the user interface that you need to test. Cinnamon tests the functionality of elements on individual pages, so knowing which page and which elements you want to test is an important first step.
</p>

<p>
	Once you decide which page you're testing, you need to design and create a PageObject class to represent the page. A PageObject is an interface between your custom page and your test classes that provides a set of methods or services to manipulate UI components.<br />
    <div align="center"><img src="./img/interfaceDiagram.png" alt="Diagram of the interaction between Cinnamon tests and UI pages" width="500"/></div><br/>
     Every UI page needs an associated PageObject but a single PageObject can be used in multiple tests, so you'll never need to duplicate the code that controls the UI. Additionally, if the UI changes, you only need to edit the PageObject class instead of every test class associated with that particular page in the UI. See the Selenium <a href="https://code.google.com/p/selenium/wiki/PageObjects" target="_blank">PageObject reference</a> and <a href="https://github.com/ryojiosawa/cinnamon/wiki/PageObject-in-Cinnamon" target="_blank">PageObject in Cinnamon</a> for more details.
</p>

<p>
	Let's set up an example to get a better idea of how Cinnamon works. You'll first need to create a custom Visualforce page. See the <a href="https://developer.salesforce.com/page/Visualforce" target="_blank">Visualforce topic page</a> in the Salesforce developer library if you need help with this step. Use the following markup for this example:
	<pre><code>
&lt;apex:page standardController="Account">
&lt;apex:form >
    &lt;apex:pageBlock title="Edit Account for {!$User.FirstName}">
        &lt;apex:pageMessages />
        &lt;apex:pageBlockButtons >
            &lt;apex:commandButton id="saveBtn" value="Save" 
                                   action="{!save}"/>
        &lt;/apex:pageBlockButtons>
        &lt;apex:pageBlockSection >
            &lt;apex:pageBlockSectionItem >
                &lt;apex:outputLabel value="Account Name" for="name"/>
                &lt;apex:inputField id="name" value="{!account.name}"/>
            &lt;/apex:pageBlockSectionItem>
            &lt;apex:pageBlockSectionItem >
                &lt;apex:outputLabel value="Account Site" for="site"/>
                &lt;apex:inputField id="site" value="{!account.site}"/>
            &lt;/apex:pageBlockSectionItem>
        &lt;/apex:pageBlockSection>
    &lt;/apex:pageBlock>
&lt;/apex:form>
&lt;/apex:page>
	</code></pre>
	This definition creates this custom page:<br/><br/>
	<div align="center"><img src="./img/editAccount-ss.png" alt="Custom Visualforce Account Edit page." width="600"/></div><br/>
    For this page, you might want to test whether entering a value in the <samp>Site</samp> field and clicking <b>Save</b> actually changes the site value for that Account. To do this, you need to use PageObjects.
</p>

<p>
	<a id="apex_create"></a> To create a PageObject for our example page, you need to create a new Apex class.
    <ol>
		<li>Log in to your Salesforce organization and make sure you select the Cinnamon app from the AppPicker.</li>
		<li>Click <b>Setup</b>.</li>
		<li>Go to <b>Develop > Apex Classes</b>.</li>
		<li>Click <b>New</b>.</li>
		<li>Copy and paste the following source code into the text area:
        <pre><code>
public class EditAccountPageObject extends cinnamon.PageObject {

    cinnamon.WebElement saveBtn,
            accountName,
            site,
            ratings;

    public override void initializePageObject() {
        saveBtn = getElement(new cinnamon.VisualforceLocator('apex:inputField', 'saveBtn'));
        accountName = getElement(new cinnamon.VisualforceLocator('apex:inputField', 'name'));
        site = getElement(new cinnamon.VisualforceLocator('apex:inputField', 'site'));
        ratings = getElement(new cinnamon.VisualforceLocator('apex:inputField', 'rating'));
    }

    public EditAccountPageObject clickSave() {
        if (saveBtn == null) {
            saveBtn = getElement(new cinnamon.VisualforceLocator('apex:commandButton', 'saveBtn'));
        }
        saveBtn.click();
        selenium.waitForPageToLoad('3000');
        return this;
    }

    public EditAccountPageObject typeAccountName(String data) {
        if (accountName == null) {
            accountName = getElement(new cinnamon.VisualforceLocator('apex:inputField', 'name'));
        }
        accountName.sendKeys(data);
        return this;
    }

    public EditAccountPageObject typeAccountSite(String data) {
        if (site == null) {
            accountName = getElement(new cinnamon.VisualforceLocator('apex:inputField', 'site'));
        }
        site.sendKeys(data);
        return this;
    }
}
        </code></pre>
        </li>
		<li>Click <b>Save</b>.
	</ol>
	Let's quickly explore this class. First, notice that it extends the abstract <code>cinnamon.PageObject</code> class that provides methods for interacting with a page's UI. There are fields for each element on the page. The values of these fields are assigned in the <code>initializePageObject()</code> method by calling <code>getElement()</code> and using Cinnamon's built-in <code>VisualforceLocator</code> to determine the postition of the elements on your page. The remaining methods in this class define different actions a user might perform such as <code>clickSave()</code> and <code>typeAccountSite</code>. The return type of the method should simulate the page the user sees after performing that action. For this example, any action a user performs should keep them on the Account's Edit page.
</p>

<p>
	Now, we're ready to get started with the actual test. There are three stages in every Cinnamon test:
	<ol>
		<li>Setup - During setup, you create a test fixture that can be used throughout all phases of testing. For our example, we'll need to set up a test Account object.</li>
		<li>Testing - The testing stage is where you actually manipulate the UI and make sure it's performing as it should.</li>
		<li>Tear down - The final, tear down stage of testing is where the objects you created throughout your tests are removed and your environment is returned to its original state.</li>
	</ol>
</p>

<p>
	Here is the full source code for a test for the custom Account Edit page: 
    <pre><code>
public class TestEditAccountPage extends cinnamon.BaseTest {

    public override void setup(cinnamon.Context context) {
        Account acc = new Account();
        acc.name = 'Account' + System.currentTimeMillis();
        insert acc;
        context.put('accId', acc.Id);
    }

    public override String getStartingPath(cinnamon.Context context) {
        return '/apex/editAccount?id=' + (String) context.get('accId');
    }

    public override void test(cinnamon.Context context) {
        String accId = (String) context.get('accId');

        EditAccountPageObject page = (EditAccountPageObject) context.getPageObject(EditAccountPageObject.class);
        page.initializePageObject();

        page.typeAccountSite('San Francisco')
            .clickSave();

        Account a = [select name, site, rating from Account where Id = :accId];
        System.assert(a != null);
        System.assertEquals(a.site, 'San Francisco');
    }

    public override void tearDown(cinnamon.Context context) {
        List&lt;ID&gt; Ids = new List&lt;ID&gt;();
        Ids.add((String) context.get('accId'));
        Database.delete(Ids);
    }
}
</code></pre>
    You can add this test to your Cinnamon Test Suite by following the instructions for <a href="#apex_create">creating a new Apex class</a>. Cinnamon will automatically add your new test to the Test Console. .
	<ol>
		<li><b>Setup</b>
		<pre><code>
public class TestEditAccountPage extends cinnamon.BaseTest {
    public override void setup (cinnamon.Context context) {
        Account acc = new Account();
        acc.name = 'Account' + System.currentTimeMillis();
        insert acc;
        context.put('accId', acc.Id);
    }
        </code></pre>
        <p>
        	The first thing to notice is that, like in the <code>EditAccountPageObject</code> class, you need to extend <code>cinnamon.BaseTest</code>. Take a look at the method signature for <code>setup()</code>. It overrides the <code>setup()</code> method from the <code>BaseTest</code> class, and has a parameter of type <code>Context</code>. The Context object carries your test objects throughout the testing phase by storing them in a map.
        </p>
        <p>
        	Inside the method, you create a new Account object, assign it a name, and <em>insert it into your organization's database</em>. The final piece of the setup is to put your new account in to the context map so it can be used later on in the test.
        </p>
        </li>
        <li><b>Starting Path</b>
        <pre><code>
public override String getStartingPath(cinnamon.Context context) {
     return '/apex/editAccount?id=' + (String) context.get('accId');
}
        </code></pre>
        <p>
        	This method is a stepping stone between the setup stage and the testing stage. It's simply called <em>by the Cinnamon testing framework</em> to obtain the URL for the UI page you're testing.
        </p>
        </li>
        <li><b>Testing</b>
        	<pre><code>
public override void test(cinnamon.Context context) {
    String accId = (String) context.get('accId');
    EditAccountPageObject page = (EditAccountPageObject) context.getPageObject(EditAccountPageObject.class);
    page.initializePageObject();
        	</code></pre>
        	<p>
        		This is a long method, so let's take a breather. Again, this method overrides the <code>test()</code> method in the <code>BaseTest</code> class and takes a <code>Context</code> object as a parameter. Inside the method, you retrieve the Account Id from the context map and cast it to a String since the <code>get()</code> method returns a generic object. Now you'll need to use the <code>EditAccountPageObject</code> you created earlier, instantiating it by calling <code>context.getPageObject()</code>. Then you initialize the page object, which allows you to interact with the user interface in your tests. Let's keep moving.
        	</p>
        	<pre><code>
    page.typeAccountSite('San Francisco')
 	  .clickSave();
			</code></pre>
			<p>
				Finally, you call methods from your PageObject to execute the UI's services. Here, we are changing the Account's site to "San Francisco" and clicking the Save button. Remember that any action you want to perform in the UI needs to be defined in the associated PageObject class. Now, it's time to check whether performing these actions worked the way you expected.
			</p>
			<pre><code>
    Account a = [SELECT name, site rating FROM Account WHERE Id = :accId];
    System.assert(a !=null);
    System.assertEquals(a.site, 'San Francisco');
}
			</code></pre>
			<p>
				You first need to create a new account by retreiving the account you created during setup from the database using the Account's Id. The last two <code>assert()</code> lines ensure that this new object isn't null and that its site field equals "San Francisco." That concludes the testing stage for this example. Easy!
			</p>
        </li>

        <li><b>Tear down</b>
        <pre><code>
public override void tearDown(cinnamon.Context context) {
	List&lt;ID&gt; Ids = new List&lt;ID&gt;();
	Ids.add((String) context.get('accId'));
	Database.delete(Ids);
}
       	</code></pre>
       	<p>
       		You've made it to the last step of writing a Cinnamon test. Here, you simply create a list to store all of the objects you created during the <em>setup and testing</em> stages (again, by getting them from the context map) and then delete the objects in the list from the database.
       	</p>
       	</li>
</p>

<p>
	To execute your new test, all you need to do is navigate to the Test Console, select the checkbox next to <b>TestEditAccountPage</b>, and select the browser/operating system combination on which you want your tests to run. Finally, click <b>Execute Tests</b>. You'll see that the execution status immediately changes to "Scheduled." <br/>
    <img src="./img/test_scheduled.png" alt="Test scheduled view" width="600"/><br/>
    The status then changes to "Running," and terminates with a status of either "Passed," "Failed," or "Error."<br/>
    <img src="./img/test_passed.png" alt="Test scheduled view" width="600"/><br/>
     You can view details about the test by clicking on its name. At the bottom of the details page under Test Executions, you can see information about individual executions of the test.<br/>
    <img src="./img/test_detail.png" alt="Test execution detail page" width="600"/>
</p>
<p>
	You've successfully written and executed your first Cinnamon test! This was a simple example, but Cinnamon provides functionality for more complex testing. See the <a href="http://forcedotcom.github.io/cinnamon/docs/" target="_blank">Cinnamon Documentation</a> to see what else you can do.
</p>
