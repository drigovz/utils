using Xunit;
using FluentAssertions;
using Utils.Utilities.ConnectionStrings;

namespace Utils.Extensions.Test.ConnectionStrings
{
    public class ConnectionStringTest
    {
        protected readonly string connectionString;

        public ConnectionStringTest()
        {
            connectionString = "Data Source=server-address; initial catalog=database-name; user id=user-id; password=password-secret; Integrated Security=False;";
        }

        [Fact]
        [Trait("ConnectionString", "ExtractValue")]
        public void Should_Return_Value_Of_Server_From_Connection_String()
        {
            var server = ConnectionString.ExtractValue(connectionString, "Source=");

            server.Should().NotBeNullOrEmpty();
            server.Should().Contain("-");
            server.Should().Contain("server");
            server.Should().Contain("address");
            server.Should().Contain("server-address");
        }

        [Fact]
        [Trait("ConnectionString", "ExtractValue")]
        public void Should_Return_Value_Of_Database_Name_From_Connection_String()
        {
            var database = ConnectionString.ExtractValue(connectionString, "Catalog=");

            database.Should().NotBeNullOrEmpty();
            database.Should().Contain("-");
            database.Should().Contain("database");
            database.Should().Contain("name");
            database.Should().Contain("database-name");
        }

        [Fact]
        [Trait("ConnectionString", "ExtractValue")]
        public void Should_Return_Value_Of_User_Id_From_Connection_String()
        {
            var user = ConnectionString.ExtractValue(connectionString, "Id=");

            user.Should().NotBeNullOrEmpty();
            user.Should().Contain("-");
            user.Should().Contain("user");
            user.Should().Contain("id");
            user.Should().Contain("user-id");
        }

        [Fact]
        [Trait("ConnectionString", "ExtractValue")]
        public void Should_Return_Value_Of_Password_From_Connection_String()
        {
            var password = ConnectionString.ExtractValue(connectionString, "Password=");

            password.Should().NotBeNullOrEmpty();
            password.Should().Contain("-");
            password.Should().Contain("password");
            password.Should().Contain("secret");
            password.Should().Contain("password-secret");
        }

        [Fact]
        [Trait("ConnectionString", "ExtractValue")]
        public void Should_Return_Values_Of_Connection_String()
        {
            var server = ConnectionString.ExtractValue(connectionString, "Source=");
            var database = ConnectionString.ExtractValue(connectionString, "Catalog=");
            var user = ConnectionString.ExtractValue(connectionString, "Id=");
            var password = ConnectionString.ExtractValue(connectionString, "Password=");

            server.Should().NotBeNullOrEmpty();
            server.Should().Contain("-");
            server.Should().Contain("server");
            server.Should().Contain("address");
            server.Should().Contain("server-address");
            database.Should().NotBeNullOrEmpty();
            database.Should().Contain("-");
            database.Should().Contain("database");
            database.Should().Contain("name");
            database.Should().Contain("database-name");
            user.Should().NotBeNullOrEmpty();
            user.Should().Contain("-");
            user.Should().Contain("user");
            user.Should().Contain("id");
            user.Should().Contain("user-id");
            password.Should().NotBeNullOrEmpty();
            password.Should().Contain("-");
            password.Should().Contain("password");
            password.Should().Contain("secret");
            password.Should().Contain("password-secret");
        }
    }
}
