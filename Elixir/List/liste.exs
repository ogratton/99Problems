defmodule Liste do

    @doc """
    # *) Find the last element of a list.
    # Example:
    # ?- my_last(X,[a,b,c,d]).
    # X = d
    """
    def my_last([element|[]]) do
        element
    end

    def my_last([_|tail]) do
        my_last(tail)
    end

    @doc """
    #  (*) Find the last but one element of a list.
    # (zweitletztes Element, l'avant-dernier élément)
    """
    def last_but_one([element|[_|[]]]) do
        element
    end

    def last_but_one([_|tail]) do
        last_but_one(tail)
    end

    @doc """
    #  (*) Find the K'th element of a list.
    # The first element in the list is number 1.
    # Example:
    # ?- element_at(X,[a,b,c,d,e],3).
    # X = c
    """
    def element_at([], n) when n >= 0 do
        :error
    end

    def element_at([element|_], 0) do
        element
    end

    def element_at([_|tail], n) do
        element_at(tail, n-1)
    end

    @doc """
    # (*) Find the number of elements of a list.
    """
    def myLength(liste) do
        myLength(liste,0)
    end

    defp myLength([_|tail], n) do
        myLength(tail, n+1)
    end

    defp myLength([], n) do
        n
    end

    @doc """
    # (*) Reverse a list.
    """
    def reverse(liste) do
        reverse(liste, [])
    end

    defp reverse([element|[]], liste) do
        liste ++ [element]
    end

    defp reverse([head|tail], liste) do
        liste2 = reverse(tail, liste)
        liste2 ++ [head]
    end

    @doc """
    # (*) Find out whether a list is a palindrome.
    # A palindrome can be read forward or backward; e.g. [x,a,m,a,x].
    """
    def pallindrome(liste) do
        liste == reverse(liste)
    end

    @doc """
    # (**) Flatten a nested list structure.
    # Transform a list, possibly holding lists as elements into a `flat' list by replacing each list with its elements (recursively).

    # Example:
    # ?- my_flatten([a, [b, [c, d], e]], X).
    # X = [a, b, c, d, e]
    """
    def flatten(liste) do
        flatten(liste, [])
    end

    defp flatten([element|[]], res) do
        case is_list(element) do
            false ->
                res ++ [element]
            true ->
                res ++ flatten(element)
        end
    end

    defp flatten([head|tail], res) do
        case is_list(head) do
            false -> 
                liste2 = [head] ++ flatten(tail)
                res = res ++ liste2    
            true ->
                liste2 = flatten(head) ++ flatten(tail)
                res = res ++ liste2
        end
    end

    @doc """
    # (**) Eliminate consecutive duplicates of list elements.
    # If a list contains repeated elements they should be replaced with a single copy of the element. The order of the elements should not be changed.

    # Example:
    iex> Liste.compress(Liste.compress([1,1,1,1,2,3,3,3,1,1,4,5,5,5,5])).
    [1, 2, 3, 1, 4, 5]
    """
    def compress(liste) do
        compress(liste,[])
    end

    defp compress([], res) do
        Enum.reverse(res)
    end
    
    defp compress([head|tail], res) do
        if length(res) > 0 and hd(res) == head do
            compress(tail, res)
        else
            compress(tail,[head] ++ res)
        end
    end

    @doc """
    (**) Pack consecutive duplicates of list elements into sublists.
    If a list contains repeated elements they should be placed in separate sublists.

    Example:
    ?- pack([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
    X = [[a,a,a,a],[b],[c,c],[a,a],[d],[e,e,e,e]]
    """
    def pack(liste) do
        pack(liste, [])
    end

    defp pack([], res) do
        res
    end
    
    defp pack([head|tail], res) do
        [new_liste, new_res] = subpack(tail,[head])
        pack(new_liste, res ++ [new_res])
    end

    defp subpack([], res) do
        [[], res]
    end

    defp subpack([head|tail], res) do
        if head == hd(res) do
            subpack(tail, [head] ++ res)
        else
            [[head|tail],res]
        end
    end

    @doc """
    (*) Run-length encoding of a list.
    Use the result of problem P09 to implement the so-called run-length encoding data compression method. Consecutive duplicates of elements are encoded as terms [N,E] where N is the number of duplicates of the element E.

    Example:
    ?- encode([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
    X = [[4,a],[1,b],[2,c],[2,a],[1,d][4,e]]
    """
    def encode(liste) do
        subencode(pack(liste), [])
    end

    defp subencode([], res) do
        res
    end
    defp subencode([head|tail], res) do
        element = hd(head)
        size = length(head)
        subencode(tail, res ++ [[size,element]])
    end

    @doc """
     (*) Modified run-length encoding.
    Modify the result of problem P10 in such a way that if an element has no duplicates it is simply copied into the result list. Only elements with duplicates are transferred as [N,E] terms.

    Example:
    ?- encode_modified([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
    X = [[4,a],b,[2,c],[2,a],d,[4,e]]
    """
    def encode_modified(liste) do
        subencode_modified(pack(liste),[])
    end

    defp subencode_modified([], res) do
        res
    end
    defp subencode_modified([head|tail], res) do
        element = hd(head)
        size = length(head)
        if size == 1 do
            subencode_modified(tail, res ++ [element])
        else
            subencode_modified(tail, res ++ [[size, element]])
        end
    end

    @doc """
        (**) Decode a run-length encoded list.
    Given a run-length code list generated as specified in problem P11. Construct its uncompressed version.
    """
    def decode([]) do
        []
    end

    def decode([head|tail]) do
        if is_list(head) do
            [size, element] = head
            subdecode(size, element) ++ decode(tail)
        else
            [head] ++ decode(tail)
        end
    end

    defp subdecode(n,element) when n == 1 do
        [element]
    end
    
    defp subdecode(n, element) when n > 1 do
        [element] ++ subdecode(n-1, element)
    end

    @doc """
    (**) Run-length encoding of a list (direct solution).
    Implement the so-called run-length encoding data compression method directly. I.e. don't explicitly create the sublists containing the duplicates, as in problem P09, but only count them. As in problem P11, simplify the result list by replacing the singleton terms [1,X] by X.

    Example:
    ?- encode_direct([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
    X = [[4,a],b,[2,c],[2,a],d,[4,e]]
    """
    def encode_direct([]) do
        []
    end
    
    def encode_direct([head|tail]) do
        [new_tail, tmp_encode] = count(tail, head, 1)
        [tmp_encode] ++ encode_direct(new_tail)
    end

    defp count([], element, n) do
        [[], [n, element]]
    end

    defp count([head|tail], element, n) do
        if head == element do
            count(tail, element, n+1)
        else
            [[head|tail], [n,element]]
        end
    end
    
    @doc """
    (*) Duplicate the elements of a list.
    Example:
    ?- dupli([a,b,c,c,d],X).
    X = [a,a,b,b,c,c,c,c,d,d]
    """
    def dupli([]) do
        []
    end

    def dupli([head|tail]) do
        [head, head] ++ dupli(tail)
    end

    @doc """
    (**) Duplicate the elements of a list a given number of times.
    Example:
    ?- dupli([a,b,c],3,X).
    X = [a,a,a,b,b,b,c,c,c]

    What are the results of the goal:
    ?- dupli(X,3,Y).
    """
    def dupli([],_n) do
        []
    end

    def dupli([head|tail],n) do
        multi(head,n) ++ dupli(tail, n)
    end
    
    defp multi(_element, 0) do
        []
    end

    defp multi(element, n) do
        [element] ++ multi(element, n-1)
    end

    @doc """
    (**) Drop every N'th element from a list.
    Example:
    ?- drop([a,b,c,d,e,f,g,h,i,k],3,X).
    X = [a,b,d,e,g,h,k]
    """
    def drop([],_n) do
        []
    end

    def drop([_head|tail], n) when n == 1 do
        drop(tail,3)
    end

    def drop([head|tail], n) when n != 1 do
        [head] ++ drop(tail, n-1)
    end

    @doc """
    (*) Split a list into two parts; the length of the first part is given.
    Do not use any predefined predicates.

    Example:
    ?- split([a,b,c,d,e,f,g,h,i,k],3,L1,L2).
    L1 = [a,b,c]
    L2 = [d,e,f,g,h,i,k]
    """
    def split(liste,n) do
        split(liste, n, [])
    end
    
    defp split(liste,n, res) when n == 0 do
        [res,liste]
    end

    defp split([head|tail],n,res) when n >= 1 do
        split(tail, n-1, res ++ [head])
    end

    @doc """
    (**) Extract a slice from a list.
    Given two indices, I and K, the slice is the list containing the elements between the I'th and K'th element of the original list (both limits included). Start counting the elements with 1.

    Example:
    ?- slice([a,b,c,d,e,f,g,h,i,k],3,7,L).
    X = [c,d,e,f,g]
    """

    def slice(liste, beginV, endV) do
        slice(liste, beginV, endV, beginV)
    end

    defp slice([_|tail], beginV, endV, count) when count > 1 do
        slice(tail, beginV, endV, count-1)
    end

    defp slice(liste, beginV, endV, count) when count == 1 do
        slice(liste, endV-beginV)
    end

    defp slice([head|tail], endV) when endV > 0 do
        [head] ++ slice(tail, endV-1)
    end
    defp slice([head|_], endV) when endV == 0 do
        [head]
    end
    defp slice([], _) do
        []
    end


end
