const Aadhaar = artifacts.require("Aadhaar");

contract("Aadhaar", (accounts) => {
  let aadhaarInstance;
  const [user, company] = accounts;

  beforeEach(async () => {
    aadhaarInstance = await Aadhaar.new();
  });

  it("should allow a user to set their Aadhaar data", async () => {
    await aadhaarInstance.setUserAadhaar("John Doe", "01-01-1990", "123 ABC Street", "Male", { from: user });
    const userAadhaar = await aadhaarInstance.aadhaarMapping(user);

    assert.equal(userAadhaar.name, "John Doe", "Name was not set correctly");
    assert.equal(userAadhaar.DOB, "01-01-1990", "DOB was not set correctly");
    assert.equal(userAadhaar.HomeAddress, "123 ABC Street", "Home address was not set correctly");
    assert.equal(userAadhaar.gender, "Male", "Gender was not set correctly");
  });

  it("should emit event when a company requests access to Name", async () => {
    const tx = await aadhaarInstance.requestAccessName(user, { from: company });

    assert.equal(tx.logs[0].event, "userNotification", "Event should be emitted");
    assert.equal(tx.logs[0].args.field, "name", "Field should be 'name'");
    assert.equal(tx.logs[0].args.company, company, "Company address should match");
    assert.equal(tx.logs[0].args.user, user, "User address should match");
  });

  it("should allow user to grant access to Name and store company address", async () => {
    await aadhaarInstance.requestAccessName(user, { from: company });
    await aadhaarInstance.grantAccessName(user, { from: user });

    const accessList = await aadhaarInstance.accessMappingName(user);
    assert.equal(accessList[0], company, "Company should have access to name");
  });

  it("should only allow the user to grant access to their Name", async () => {
    try {
      await aadhaarInstance.grantAccessName(user, { from: company });
      assert.fail("Only the user should be able to grant access");
    } catch (error) {
      assert(error.message.includes("Only the user can grant access"), "Expected revert");
    }
  });

  it("should prevent duplicate company addresses in access list for Name", async () => {
    await aadhaarInstance.requestAccessName(user, { from: company });
    await aadhaarInstance.grantAccessName(user, { from: user });

    // Request access again and try granting it again
    await aadhaarInstance.requestAccessName(user, { from: company });
    await aadhaarInstance.grantAccessName(user, { from: user });

    const accessList = await aadhaarInstance.accessMappingName(user);
    assert.equal(accessList.length, 1, "Duplicate entries should not be added");
  });

  it("should allow a company to request access to DOB", async () => {
    const tx = await aadhaarInstance.requestAccessDOB(user, { from: company });

    assert.equal(tx.logs[0].event, "userNotification", "Event should be emitted");
    assert.equal(tx.logs[0].args.field, "DOB", "Field should be 'DOB'");
    assert.equal(tx.logs[0].args.company, company, "Company address should match");
    assert.equal(tx.logs[0].args.user, user, "User address should match");
  });

  it("should allow user to grant access to DOB", async () => {
    await aadhaarInstance.requestAccessDOB(user, { from: company });
    await aadhaarInstance.grantAccessDOB(user, { from: user });

    const accessList = await aadhaarInstance.accessMappingDOB(user);
    assert.equal(accessList[0], company, "Company should have access to DOB");
  });

  it("should emit event when a company requests access to Gender", async () => {
    const tx = await aadhaarInstance.requestAccessGender(user, { from: company });

    assert.equal(tx.logs[0].event, "userNotification", "Event should be emitted");
    assert.equal(tx.logs[0].args.field, "Gender", "Field should be 'Gender'");
    assert.equal(tx.logs[0].args.company, company, "Company address should match");
    assert.equal(tx.logs[0].args.user, user, "User address should match");
  });

  it("should allow user to grant access to Gender", async () => {
    await aadhaarInstance.requestAccessGender(user, { from: company });
    await aadhaarInstance.grantAccessGender(user, { from: user });

    const accessList = await aadhaarInstance.accessMappingGender(user);
    assert.equal(accessList[0], company, "Company should have access to Gender");
  });

});
