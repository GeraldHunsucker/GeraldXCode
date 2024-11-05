import SwiftUI

class PrintableViewController: NSViewController {
    let layouts: [CutLayout]
    let size: CGSize
    var onViewReady: ((NSView) -> Void)?
    
    init(layouts: [CutLayout], size: CGSize) {
        self.layouts = layouts
        self.size = size
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let layouts = self.layouts
        let contentView = VStack(spacing: 40) {
            ForEach(layouts) { layout in
                VStack(alignment: .leading, spacing: 8) {
                    if let index = layouts.firstIndex(where: { $0.id == layout.id }) {
                        Text("Sheet \(index + 1)")
                            .font(.title2)
                    }
                    RenderableLayoutView(layout: layout)
                        .frame(
                            width: layout.material.width * 4,
                            height: layout.material.length * 4
                        )
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .shadow(radius: 2)
                )
            }
        }
        .padding(40)
        .background(Color.white)
        .frame(width: size.width, height: size.height)
        
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.frame = CGRect(origin: .zero, size: size)
        hostingView.wantsLayer = true
        hostingView.layer?.backgroundColor = NSColor.white.cgColor
        
        self.view = hostingView
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        onViewReady?(self.view)
    }
} 