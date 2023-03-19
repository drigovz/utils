using System.Text.RegularExpressions;

namespace Utils.Utilities.ConnectionStrings
{
    public static class ConnectionString
    {
        public static string ExtractValue(string connectionString, string matchCase)
        {
            if (string.IsNullOrEmpty(connectionString) || string.IsNullOrEmpty(matchCase))
                return "";

            var match = Regex.Match(connectionString, @$"{matchCase}([A-Za-z0-9-_.@#$%¨!*()+]+)", RegexOptions.IgnoreCase);
            return match.Success ? match?.Groups[1]?.Value : "";
        }
    }
}
