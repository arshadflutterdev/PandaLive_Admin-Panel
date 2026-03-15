// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:google_fonts/google_fonts.dart';

// class UserPrewiew extends StatefulWidget {
//   final Map<String, dynamic> userData;
//   final String docId;

//   const UserPrewiew({super.key, required this.userData, required this.docId});

//   @override
//   State<UserPrewiew> createState() => _UserPrewiewState();
// }

// class _UserPrewiewState extends State<UserPrewiew> {
//   bool isVerified = false;

//   @override
//   void initState() {
//     super.initState();
//     isVerified = widget.userData['isVerified'] ?? false;
//   }

//   // Verification status update karne ka function
//   Future<void> _toggleVerification() async {
//     await FirebaseFirestore.instance
//         .collection("userProfile")
//         .doc(widget.docId)
//         .update({"isVerified": !isVerified});

//     setState(() {
//       isVerified = !isVerified;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F7FE),
//       appBar: AppBar(
//         title: Text(
//           "User Profile",
//           style: GoogleFonts.inter(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         foregroundColor: Colors.black,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Profile Image Section
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(15),
//                     child: Image.network(
//                       widget.userData['userimage'] ?? "",
//                       width: 250,
//                       height: 250,
//                       fit: BoxFit.cover,
//                       errorBuilder: (c, e, s) => Container(
//                         width: 250,
//                         height: 250,
//                         color: Colors.grey[200],
//                         child: const Icon(Icons.person, size: 100),
//                       ),
//                     ),
//                   ),
//                   const Gap(30),
//                   // Fields Section
//                   Expanded(
//                     child: Wrap(
//                       spacing: 20,
//                       runSpacing: 20,
//                       children: [
//                         _buildProfileField(
//                           "Name",
//                           widget.userData['name'] ?? "N/A",
//                         ),
//                         _buildProfileField(
//                           "User name",
//                           "@${widget.userData['userId'] ?? 'unknown'}",
//                         ),
//                         _buildProfileField(
//                           "Gender",
//                           widget.userData['gender'] ?? "N/A",
//                         ),
//                         _buildProfileField(
//                           "Country",
//                           widget.userData['country'] ?? "Global",
//                         ),
//                         _buildProfileField(
//                           "Coins",
//                           "${widget.userData['coins'] ?? 0}",
//                         ),
//                         _buildProfileField("Login Type", "Quick"),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const Gap(40),
//               const Divider(),
//               const Gap(20),
//               // Action Button for Blue Tick
//               Row(
//                 children: [
//                   Text(
//                     "Account Verification Status:",
//                     style: GoogleFonts.inter(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const Gap(15),
//                   ElevatedButton.icon(
//                     onPressed: _toggleVerification,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: isVerified
//                           ? Colors.blue
//                           : Colors.grey[200],
//                       foregroundColor: isVerified ? Colors.white : Colors.black,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 15,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     icon: Icon(
//                       isVerified ? Icons.verified : Icons.verified_outlined,
//                     ),
//                     label: Text(
//                       isVerified
//                           ? "Verified (Click to Remove)"
//                           : "Give Blue Tick",
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileField(String label, String value) {
//     return SizedBox(
//       width: 300,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 14),
//           ),
//           const Gap(8),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF4F7FE),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               value,
//               style: GoogleFonts.inter(fontWeight: FontWeight.w500),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class UserPrewiew extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String docId;

  const UserPrewiew({super.key, required this.userData, required this.docId});

  @override
  State<UserPrewiew> createState() => _UserPrewiewState();
}

class _UserPrewiewState extends State<UserPrewiew> {
  bool isVerified = false;

  @override
  void initState() {
    super.initState();
    // FIX: String "pending" ko handle karne ke liye check lagaya hai
    var verifiedData = widget.userData['isVerified'];
    if (verifiedData is bool) {
      isVerified = verifiedData;
    } else {
      isVerified = false; // Agar "pending" ya kuch aur ho toh default false
    }
  }

  Future<void> _toggleVerification() async {
    bool newStatus = !isVerified;
    await FirebaseFirestore.instance
        .collection("userProfile")
        .doc(widget.docId)
        .update({"isVerified": newStatus});

    setState(() {
      isVerified = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Screen width check karne ke liye
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      appBar: AppBar(
        title: Text(
          "User Profile",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 12 : 24),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Responsive Layout Row/Column
              isMobile
                  ? Column(children: _buildProfileHeader(isMobile))
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildProfileHeader(isMobile),
                    ),

              const Gap(40),
              const Divider(),
              const Gap(20),

              // Verification Section
              isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Verification Status:",
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                        const Gap(10),
                        _buildVerifyButton(),
                      ],
                    )
                  : Row(
                      children: [
                        Text(
                          "Account Verification Status:",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const Gap(15),
                        _buildVerifyButton(),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Header content (Image + Info) ko reuse karne ke liye list
  List<Widget> _buildProfileHeader(bool isMobile) {
    return [
      ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          widget.userData['userimage'] ?? "",
          width: isMobile ? double.infinity : 250,
          height: isMobile ? 300 : 250,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => Container(
            width: isMobile ? double.infinity : 250,
            height: isMobile ? 300 : 250,
            color: Colors.grey[200],
            child: const Icon(Icons.person, size: 80),
          ),
        ),
      ),
      isMobile ? const Gap(20) : const Gap(30),
      Expanded(
        flex: isMobile ? 0 : 1,
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            _buildProfileField(
              "Name",
              widget.userData['name'] ?? "N/A",
              isMobile,
            ),
            _buildProfileField(
              "User name",
              "@${widget.userData['userId'] ?? 'unknown'}",
              isMobile,
            ),
            _buildProfileField(
              "Gender",
              widget.userData['gender'] ?? "N/A",
              isMobile,
            ),
            _buildProfileField(
              "Country",
              widget.userData['country'] ?? "Global",
              isMobile,
            ),
            _buildProfileField(
              "Coins",
              "${widget.userData['coins'] ?? 0}",
              isMobile,
            ),
            _buildProfileField("Login Type", "Quick", isMobile),
          ],
        ),
      ),
    ];
  }

  Widget _buildVerifyButton() {
    return ElevatedButton.icon(
      onPressed: _toggleVerification,
      style: ElevatedButton.styleFrom(
        backgroundColor: isVerified ? Colors.blue : Colors.grey[200],
        foregroundColor: isVerified ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(200, 50),
      ),
      icon: Icon(isVerified ? Icons.verified : Icons.verified_outlined),
      label: Text(isVerified ? "Verified (Click to Remove)" : "Give Blue Tick"),
    );
  }

  Widget _buildProfileField(String label, String value, bool isMobile) {
    return SizedBox(
      width: isMobile ? double.infinity : 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 13),
          ),
          const Gap(6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
