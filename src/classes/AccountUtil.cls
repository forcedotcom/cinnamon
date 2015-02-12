public with sharing class AccountUtil {
	public static Account create(String name) {
		Map<String, Schema.SObjectField> fields = Schema.SObjectType.Account.fields.getMap();
		SObject newAccount =  (new Account()).getSObjectType().newSObject();
		for(String fieldName: fields.keyset()) {
		    if(fieldName.equalsIgnoreCase('ownerId')) continue;
		    Schema.DescribeFieldResult dfr = fields.get(fieldName).getDescribe();
		    if(!dfr.isNillable() && dfr.isCreateable()) {
		        newAccount.put(fieldName, name);
		    }
		}
		insert newAccount;	
		return (Account)newAccount;	
	}
}