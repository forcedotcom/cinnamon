public class TestNewAccount extends cinnamon.BaseTest {
    public override String getStartingPath(cinnamon.Context context) {
        return NewAccountPageObject.getInstance(context).getPathAndQuery();
    }
    
    public override void test(cinnamon.Context context) {
        NewAccountPageObject page = NewAccountPageObject.getInstance(context);
        page.saveNewAccount('accountName');
    }
}