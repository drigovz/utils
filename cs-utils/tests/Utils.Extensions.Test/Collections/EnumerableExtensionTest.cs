using System.Collections.Generic;
using Xunit;
using FluentAssertions;

namespace Utils.Extensions.Test.Collections
{
    public class EnumerableExtensionTest
    {
        [Fact]
        [Trait("Enumerable", "CollectionIsNull")]
        public void Should_True_If_Collection_Is_Null()
        {
            List<char> collection = null;

            collection.IsNullOrEmpty().Should().BeTrue();
        }

        [Fact]
        [Trait("Enumerable", "CollectionIsEmpty")]
        public void Should_True_If_Collection_Is_Empty()
        {
            List<char> collection = new();

            collection.IsNullOrEmpty().Should().BeTrue();
        }

        [Fact]
        [Trait("Enumerable", "CollectionNotIsNullOrEmpty")]
        public void Should_False_If_Collection_Not_Is_Empty_And_Not_Null()
        {
            List<char> collection = new() { 'a', 'b', 'c' };
               
            collection.IsNullOrEmpty().Should().BeTrue();
        }
    }
}
