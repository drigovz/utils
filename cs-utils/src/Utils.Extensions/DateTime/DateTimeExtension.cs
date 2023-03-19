namespace System
{
    public static class DateTimeExtension
    {
        public static string DateTimeToUtcFormatString(this DateTime dateTime)
            => dateTime.ToUniversalTime().ToString("yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fff'Z'");
    }
}
