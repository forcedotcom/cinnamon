public with sharing class NewAccountPageObject extends cinnamon.PageObject{
	cinnamon.WebElement saveButton;
	cinnamon.WebElement accountNameInput;
	
	public override void initializePageObject() {
		saveButton = getElement(new cinnamon.VisualforceLocator('apex:commandButton', 'saveBtn'));
		accountNameInput = getElement(new cinnamon.VisualforceLocator('apex:inputField', 'name'));
	}
	
	public void saveNewAccount(String accountName) {
		accountNameInput.sendKeys(accountName);
		saveButton.click();
		getWait().until(cinnamon.expectedConditions.titleToContain(accountName));
	}
	
	public override String getPathAndQuery(Map<String, String> params) {
		if(params==null) {
			return '/apex/NewAccountPage';
		} else {
			return '/apex/NewAccountPage?id=' + params.get('accId');
		}

	}
	
	public static NewAccountPageObject getInstance(cinnamon.context context) {
		return (NewAccountPageObject) context.getPageObject(NewAccountPageObject.class);
	}
}