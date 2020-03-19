import java.util.Iterator;
import java.util.Stack;

// https://www.geeksforgeeks.org/avl-tree-set-1-insertion/ 
// I modified the code to generic class
class Node<T> {
  T key;
  int height; 
  Node<T> left, right; 

  Node(T d) { 
    key = d; 
    height = 1;
  }
}

class TreeIterator<T> implements Iterator<T> {
  private Stack<Node<T>> stack;

  public TreeIterator(Node<T> tempNode) {
    stack = new Stack<Node<T>>();

    while (tempNode != null) {
      stack.push(tempNode);
      tempNode = tempNode.left;
    }
  }

  public boolean hasNext() {
    return !stack.isEmpty();
  }

  public T next() {
    Node<T> popedNode = stack.pop();
    T v = popedNode.key;

    if (popedNode.right != null) {
      popedNode = popedNode.right;
      while (popedNode != null) {
        stack.push(popedNode);
        popedNode = popedNode.left;
      }
    }
    return v;
  }

  public void remove() {
    throw new UnsupportedOperationException();
  }
}

class AVLTree<T extends Comparable<T>> implements Iterable<T> { 
  Node root; 

  public Iterator<T> iterator() {
    return new TreeIterator<T>(root);
  }

  public Node<T> search(Node<T> root, T key) 
  { 
    // Base Cases: root is null or key is present at root 
    if (root == null || key.equals(root.key)) 
      return root; 

    // val is greater than root's key 
    if (key.compareTo(root.key) < 0) 
      return search(root.left, key); 

    // val is less than root's key 
    return search(root.right, key);
  } 

  // A utility function to get the height of the tree 
  int height(Node<T> N) { 
    if (N == null) 
      return 0; 

    return N.height;
  } 

  // A utility function to get maximum of two integers 
  int max(int a, int b) { 
    return (a > b) ? a : b;
  } 

  // A utility function to right rotate subtree rooted with y 
  // See the diagram given above. 
  private Node<T> rightRotate(Node<T> y) { 
    Node<T> x = y.left; 
    Node<T> T2 = x.right; 

    // Perform rotation 
    x.right = y; 
    y.left = T2; 

    // Update heights 
    y.height = max(height(y.left), height(y.right)) + 1; 
    x.height = max(height(x.left), height(x.right)) + 1; 

    // Return new root 
    return x;
  } 

  // A utility function to left rotate subtree rooted with x 
  // See the diagram given above. 
  private Node<T> leftRotate(Node<T> x) { 
    Node<T> y = x.right; 
    Node<T> T2 = y.left; 

    // Perform rotation 
    y.left = x; 
    x.right = T2; 

    //  Update heights 
    x.height = max(height(x.left), height(x.right)) + 1; 
    y.height = max(height(y.left), height(y.right)) + 1; 

    // Return new root 
    return y;
  } 

  // Get Balance factor of node N 
  int getBalance(Node<T> N) { 
    if (N == null) 
      return 0; 

    return height(N.left) - height(N.right);
  } 

  public Node<T> insert(Node<T> node, T key) { 

    /* 1.  Perform the normal BST insertion */
    if (node == null) 
      return (new Node<T>(key)); 

    if (key.compareTo(node.key) < 0) 
      node.left = insert(node.left, key); 
    else if (key.compareTo(node.key) > 0) 
      node.right = insert(node.right, key); 
    else
      throw new RuntimeException("duplicate Key!");


    /* 2. Update height of this ancestor node */
    node.height = 1 + max(height(node.left), 
      height(node.right)); 

    /* 3. Get the balance factor of this ancestor 
     node to check whether this node became 
     unbalanced */
    int balance = getBalance(node); 

    // If this node becomes unbalanced, then there 
    // are 4 cases Left Left Case 
    if (balance > 1 && key.compareTo(node.left.key) < 0) 
      return rightRotate(node); 

    // Right Right Case 
    if (balance < -1 && key.compareTo(node.right.key) > 0) 
      return leftRotate(node); 

    // Left Right Case 
    if (balance > 1 && key.compareTo(node.left.key) > 0) { 
      node.left = leftRotate(node.left); 
      return rightRotate(node);
    } 

    // Right Left Case 
    if (balance < -1 && key.compareTo(node.right.key) < 0) { 
      node.right = rightRotate(node.right); 
      return leftRotate(node);
    } 

    /* return the (unchanged) node pointer */
    return node;
  } 

  // A utility function to print preorder traversal 
  // of the tree. 
  // The function also prints height of every node 
  public void preOrder(Node<T> node) { 
    if (node != null) { 
      print(node.key + " "); 
      preOrder(node.left); 
      preOrder(node.right);
    }
  } 

  /* Given a non-empty binary search tree, return the  
   node with minimum key value found in that tree.  
   Note that the entire tree does not need to be  
   searched. */
  private Node<T> minValueNode(Node<T> node) {  
    Node<T> current = node;  

    /* loop down to find the leftmost leaf */
    while (current.left != null)  
      current = current.left;  

    return current;
  }  

  public Node<T> deleteNode(Node<T> root, T key)  
  {  
    // STEP 1: PERFORM STANDARD BST DELETE  
    if (root == null)  
      return root;  

    // If the key to be deleted is smaller than  
    // the root's key, then it lies in left subtree  
    if (key.compareTo(root.key) < 0)  
      root.left = deleteNode(root.left, key);  

    // If the key to be deleted is greater than the  
    // root's key, then it lies in right subtree  
    else if (key.compareTo(root.key) > 0)  
      root.right = deleteNode(root.right, key);  

    // if key is same as root's key, then this is the node  
    // to be deleted  
    else
    {  

      // node with only one child or no child  
      if ((root.left == null) || (root.right == null))  
      {  
        Node<T> temp = null;  
        if (temp == root.left)  
          temp = root.right;  
        else
          temp = root.left;  

        // No child case  
        if (temp == null)  
        {  
          temp = root;  
          root = null;
        } else // One child case  
        root = temp; // Copy the contents of  
        // the non-empty child
      } else
      {  

        // node with two children: Get the inorder  
        // successor (smallest in the right subtree)  
        Node<T> temp = minValueNode(root.right);  

        // Copy the inorder successor's data to this node  
        root.key = temp.key;  

        // Delete the inorder successor  
        root.right = deleteNode(root.right, temp.key);
      }
    }  

    // If the tree had only one node then return  
    if (root == null)  
      return root;  

    // STEP 2: UPDATE HEIGHT OF THE CURRENT NODE  
    root.height = max(height(root.left), height(root.right)) + 1;  

    // STEP 3: GET THE BALANCE FACTOR OF THIS NODE (to check whether  
    // this node became unbalanced)  
    int balance = getBalance(root);  

    // If this node becomes unbalanced, then there are 4 cases  
    // Left Left Case  
    if (balance > 1 && getBalance(root.left) >= 0)  
      return rightRotate(root);  

    // Left Right Case  
    if (balance > 1 && getBalance(root.left) < 0)  
    {  
      root.left = leftRotate(root.left);  
      return rightRotate(root);
    }  

    // Right Right Case  
    if (balance < -1 && getBalance(root.right) <= 0)  
      return leftRotate(root);  

    // Right Left Case  
    if (balance < -1 && getBalance(root.right) > 0)  
    {  
      root.right = rightRotate(root.right);  
      return leftRotate(root);
    }  

    return root;
  }
} 
// This code has been contributed by Mayank Jaiswal 
