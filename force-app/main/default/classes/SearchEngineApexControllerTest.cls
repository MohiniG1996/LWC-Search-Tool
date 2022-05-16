@isTest
public class SearchEngineApexControllerTest {
    
    @testSetup 
    static void setup() {
        Account AccountTest = new Account();
        AccountTest.Name = 'AccountTest1';
        Insert AccountTest;
    }
    
    private static Account createAcc(String name) {
        Account acc = new Account(Name = name);
        insert acc;
        return acc;
    } 

    @isTest
    static void TestGetAllRecord(){
        SearchEngineApexController searchEngineObj = new SearchEngineApexController (); 
        Account acc = createAcc('Berlin');
        SearchEngineApexController.getAllRecord('Contact', 'LastName', '200');
        SearchEngineApexController.ObjectDetailsWrapper wrapperObj = new SearchEngineApexController.ObjectDetailsWrapper();
        system.assertEquals(200, wrapperObj.allRecords.size());
        
    }
    
    @isTest
    static void TestGetAllRecordInvalid(){
        
        Account acc = createAcc('Berlin');
        SearchEngineApexController.getAllRecord('Contact', 'LastName12', '2006');
        SearchEngineApexController.ObjectDetailsWrapper wrapperObj = new SearchEngineApexController.ObjectDetailsWrapper();
        System.assertNotEquals(200,wrapperObj.allRecords.size());
        
    }
    
    @isTest
    static void TestUpdateAccount(){
        
        List<Account> accRec = [select id,name from account where name='AccountTest1'];
        
        SearchEngineApexController.UpdateObject(accRec);
    }
}