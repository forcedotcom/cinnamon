public with sharing class TestEditAccount extends cinnamon.BaseTest {
	public override void setup(cinnamon.Context context) {
		Account acc = AccountUtil.create('New Acc');
		context.put('accId', acc.id);
	}

	public override String getStartingPath(cinnamon.context context) {
		Map<String, String> params = new Map<String, String>();
		params.put('accId', context.getString('accId'));
		return NewAccountPageObject.getInstance(context).getPathAndQuery(params);
	}

	public override void test(cinnamon.context context) {
		NewAccountPageObject.getInstance(context).saveNewAccount('Newer Newest Account');

		Account acc = [select name from account where id = :context.getString('accId')];
		cinnamon.assert.assert('Account name was not changed', acc.name.equals('Newer Newest Account'));
	}
}