//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)

        // MARK: Create SubViews
        let frame1 = CGRect(x:30, y: 10, width: 240, height: 280)
        let subview1 = viewBuilder(frame: frame1, tag: 1, backgroundColor: .green)

        let frame2 = CGRect(x:230, y: 20, width: 140, height: 80)
        let subview2 = viewBuilder(frame: frame2, tag: 2, backgroundColor: .red)

        let frame3 = CGRect(x:30, y: 10, width: 40, height: 80)
        let subview3 = viewBuilder(frame: frame3, tag: 3, backgroundColor: .blue)
        
        let frame4 = CGRect(x:10, y: 10, width: 20, height: 20)
        let subview4 = viewBuilder(frame: frame4, tag: 4, backgroundColor: .orange)

        // MARK: Add SubViews
        view.addSubview(subview1)
        view.addSubview(subview2)
        subview1.addSubview(subview3)
        subview3.addSubview(subview4)
        
        self.view = view
    }
    func traverseSubviews(view: UIView, withPoint point: CGPoint ) {
        // Process the current view
        var convertedPoint = point
        // We need to get the position of the touch relative to the superview of the current view
        // but if the superview is the parent Viewcontroller view we don't
        // need to do any conversion
        if view.superview != self.view {
            // we will need to transfom the point in the screen coordinates (self.view)
            // to coordinates of the view we are evaluating
            // as teh frame origin coordinate are relative to the superview where
            // I was added as a subview, that's why we need to transform them to view.superview
            convertedPoint = self.view.convert(point, to: view.superview)
        }
        //print("Processing view: \(view.tag) with point \(point) converted to \(convertedPoint)")
        if view.frame.contains(convertedPoint) {
            print("View \(view.tag) touched with converted")
        }
        // Recursively traverse subviews
        for subview in view.subviews {
            traverseSubviews(view: subview, withPoint: point)
        }
    }
    
    func traverseSubviews(view: UIView) {
        // Process the current view
        print("Processing view: \(view.tag)")

        // Recursively traverse subviews
        for subview in view.subviews {
            traverseSubviews(view: subview)
        }
    }
    
    func viewBuilder(frame: CGRect, tag: Int, backgroundColor: UIColor) -> UIView {
        let view = UIView(frame: frame)
        view.tag = tag
        view.backgroundColor = backgroundColor
        return view
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let point = sender?.location(in: self.view) else {
            return
        }
        print("///////////////////")
        print("A tap was made at \(String(describing: point))")
        traverseSubviews(view: self.view, withPoint: point)
    }
}
// Present the view controller in the Live View window
let vc = MyViewController()
PlaygroundPage.current.liveView = vc

vc.traverseSubviews(view: vc.view)
