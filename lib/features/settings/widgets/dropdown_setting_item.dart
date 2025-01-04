class DropdownSettingItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? subtitle;

  const DropdownSettingItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.text,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 16,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                color: AppColors.text.withOpacity(0.7),
                fontSize: 14,
              ),
            )
          : null,
      trailing: DropdownButton<String>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 16,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        dropdownColor: AppColors.surface,
        underline: const SizedBox(),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: AppColors.text,
        ),
      ),
    );
  }
} 