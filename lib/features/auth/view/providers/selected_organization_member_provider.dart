import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/features/auth/data/models/organization_member/organization_member.dart';

final selectedOrganizationMemberProvider =
    StateProvider<OrganizationMember?>((ref) => null);
