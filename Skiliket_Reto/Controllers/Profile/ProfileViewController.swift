import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var enrolledProjectsLabel: UILabel!
    @IBOutlet weak var publishedNewsLabel: UILabel!

    var profile: Profile?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch the profile data asynchronously
        Task {
            do {
                let fetchedProfile = try await Profile.fetchProfile()
                DispatchQueue.main.async {
                    self.profile = fetchedProfile
                    self.updateUI()
                }
            } catch {
                print("Failed to fetch profile: \(error)")
            }
        }
    }

    func updateUI() {
        guard let profile = profile else { return }

        // Update the UI elements with profile data
        usernameLabel.text = profile.username
        userIDLabel.text = profile.userID
        titleLabel.text = profile.contactInfo.title
        emailLabel.text = profile.contactInfo.email
        phoneLabel.text = profile.contactInfo.phone
        addressLabel.text = profile.contactInfo.address
        enrolledProjectsLabel.text = "\(profile.stats.enrolledProjects)"
        publishedNewsLabel.text = "\(profile.stats.publishedNews)"
        
        // Strip the extension to load the image from Assets
        let imageNameWithoutExtension = URL(fileURLWithPath: profile.profileImage).deletingPathExtension().lastPathComponent

        // Load the profile image from Assets
        if let image = UIImage(named: imageNameWithoutExtension) {
            profileImageView.image = image
        } else {
            // Fallback if the image is not found
            profileImageView.image = UIImage(systemName: "person.crop.circle")
        }
    }
}
